#!/usr/bin/env nextflow

/*
 *
 * Copyright (c) 2013-2018, Centre for Genomic Regulation (CRG).
 * Copyright (c) 2013-2018, Paolo Di Tommaso and the respective authors.
 *
 *   This file is part of 'Nextflow'.
 *
 *   Nextflow is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Nextflow is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Nextflow.  If not, see <http://www.gnu.org/licenses/>.
 */
 

/*
 * Defines the pipeline inputs parameters (giving a default value for each for them) 
 * Each of the following parameters can be specified as command line options
 */
params.query = "$baseDir/data/sample.fa"
params.db = "$baseDir/blast-db/pdb/tiny"
params.out = "s3://blast-project/results/result.txt"
params.chunkSize = 100

db_name = file(params.db).name
db_dir = file(params.db).parent

/* 
 * Given the query parameter creates a channel emitting the query fasta file(s), 
 * the file is split in chunks containing as many sequences as defined by the parameter 'chunkSize'.
 * Finally assign the result channel to the variable 'fasta_ch' 
 */
Channel
    .fromPath(params.query)
    .splitFasta(by: params.chunkSize, file:true)
    .set { fasta_ch }

/* 
 * Executes a BLAST job for each chunk emitted by the 'fasta_ch' channel 
 * and creates as output a channel named 'top_hits' emitting the resulting 
 * BLAST matches  
 */
process blast {
    input:
    path 'query.fa' from fasta_ch
    path db from db_dir

    output:
    file 'top_hits' into hits_ch

    """
    blastp -db $db/$db_name -query query.fa -outfmt 6 > blast_result
    cat blast_result | head -n 10 | cut -f 2 > top_hits
    """
}

/* 
 * Each time a file emitted by the 'top_hits' channel an extract job is executed 
 * producing a file containing the matching sequences 
 */
process extract {
    input:
    path 'top_hits' from hits_ch
    path db from db_dir

    output:
    file 'sequences' into sequences_ch

    """
    blastdbcmd -db $db/$db_name -entry_batch top_hits | head -n 10 > sequences
    """
}

/* 
 * Collects all the sequences files into a single file 
 * and prints the resulting file content when complete 
 */ 
sequences_ch
    .collectFile(name: params.out)
    .view { file -> "matching sequences:\n ${file.text}" }