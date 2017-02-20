#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing: 
      - entry: $(inputs.reference)
hints:
  DockerRequirement:
    dockerPull: opengenomics/samtools_pileup:1.1.2

label: SamTools Pileup
baseCommand: [samtools, mpileup]
# samtools mpileup  -B  -q 1  -f reference.fa > output

inputs:
  noBaq:
    type: boolean?
    doc: disable BAQ (per-Base Alignment Quality)
    default: false
    inputBinding:
      prefix: -B

  minMapQ:
    doc:   -q, --min-MQ INT        skip alignments with mapQ smaller than INT [0]
    type: int?
    default: 0
    inputBinding:
      prefix: -q
  
  reference:
    type: File
    inputBinding:
      prefix: -f
      valueFrom: $(self.basename)

  alignments:
    type: File
    inputBinding:
      position: 1
    secondaryFiles:
      - .bai

stdout: output.pileup

outputs:
  pileup:
    type: stdout
