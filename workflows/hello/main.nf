#!/usr/bin/env nextflow

cheers = Channel.from 'Bonjour', 'Ciao', 'Hello', 'Hola'

process sayHello {w
  echo true
  input:
    val x from cheers
  script:
    """
    echo '$x world!'
    """
}
