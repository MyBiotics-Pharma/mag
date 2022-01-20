// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process EXPORTSHORT {
    tag "$meta.id"
    label 'process_low'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:meta, publish_by_meta:['id']) }

    
    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("exported/*.gz"), emit: oreads
    
    script:
    // Copy the reads to outdir that will be exported
    """
    mkdir -p exported
    cp -L $reads exported
    """
}
