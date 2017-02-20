#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0

doc: "varscan_somatic workflow"

requirements:
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs: 

  TUMOR_BAM: File

  NORMAL_BAM: File

  GENO_FA_GZ: File

outputs:

  INDEL_OUTVCF:
    type: File
    outputSource: varscan/indel_vcf

  SNP_OUTVCF:
    type: File
    outputSource: varscan/snp_vcf

steps:

  zcat:
    run: zcat.cwl
    in:
      gzipFile: GENO_FA_GZ
      unzippedFileName: 
        valueFrom: $('genome.fa')
    out: [unzippedFile]

  tpileup:
    run: sam_pileup.cwl
    in:
      alignments: TUMOR_BAM
      reference: zcat/unzippedFile
    out: [pileup]

  npileup:
    run: sam_pileup.cwl
    in:
      alignments: NORMAL_BAM
      reference: zcat/unzippedFile
    out: [pileup]

  varscan:
    run: varscan_somatic.cwl
    in:
      input_normal: npileup/pileup 
      input_tumor: tpileup/pileup
    out: [snp_vcf, indel_vcf]
