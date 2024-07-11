# Janus Stacks Changelog
<!--- @generated --->


## [0.1.1](https://github.com/jhatler/janus/compare/tf-stacks-v0.1.0...tf-stacks-v0.1.1) (2024-07-11)


### Features

* Actions agent setup by ansible on runners ([#373](https://github.com/jhatler/janus/issues/373)) ([b6e9107](https://github.com/jhatler/janus/commit/b6e9107c896b811a549dc1d750afaa6e5be25809)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add admin Spacelift stack ([#294](https://github.com/jhatler/janus/issues/294)) ([5d54b46](https://github.com/jhatler/janus/commit/5d54b463c3cfd5733afd79fe2f56dfdac554f1c2)), closes [#292](https://github.com/jhatler/janus/issues/292)
* Add auth and crypto stacks ([#317](https://github.com/jhatler/janus/issues/317)) ([0ce4dda](https://github.com/jhatler/janus/commit/0ce4ddac0f938ccf996468c3c564c6646fbbe4f4))
* Add CHANGELOG/README/Tests to github_oidc ([#308](https://github.com/jhatler/janus/issues/308)) ([0d373c3](https://github.com/jhatler/janus/commit/0d373c3d32339b491e8b4cbaca158bcfcd00f3ea)), closes [#300](https://github.com/jhatler/janus/issues/300)
* Add ecr repository for webhooks ([#363](https://github.com/jhatler/janus/issues/363)) ([85f1a8e](https://github.com/jhatler/janus/commit/85f1a8e7b5701c738d809fccd3cc0aadc294d850)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add network stack ([#291](https://github.com/jhatler/janus/issues/291)) ([47eef0d](https://github.com/jhatler/janus/commit/47eef0dad11ebb36fb2740dda4dc1dcc1d0b359d)), closes [#290](https://github.com/jhatler/janus/issues/290)
* Add runner roles and webhook lambda ([#364](https://github.com/jhatler/janus/issues/364)) ([246ccb4](https://github.com/jhatler/janus/commit/246ccb48ac3dc20dc481777203035dee3ba9152d)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add runners stack to Spacelift ([#333](https://github.com/jhatler/janus/issues/333)) ([3ffcc9e](https://github.com/jhatler/janus/commit/3ffcc9e2869812d36142d7adc4df96a357eeeedd)), closes [#278](https://github.com/jhatler/janus/issues/278)
* Add ssm Spacelift stack ([#351](https://github.com/jhatler/janus/issues/351)) ([7fa380d](https://github.com/jhatler/janus/commit/7fa380dc2557cf3d26c58ab8e431f40666ccde21)), closes [#349](https://github.com/jhatler/janus/issues/349)
* Add stack for receiving webhooks ([#337](https://github.com/jhatler/janus/issues/337)) ([87ae708](https://github.com/jhatler/janus/commit/87ae708a68901faa6bdd4f5f3f4bea33b70f9818)), closes [#336](https://github.com/jhatler/janus/issues/336)
* Add stacks for ECR access ([#409](https://github.com/jhatler/janus/issues/409)) ([e7ae358](https://github.com/jhatler/janus/commit/e7ae35858383908f0938fdc6d05328937c0aa974)), closes [#406](https://github.com/jhatler/janus/issues/406)
* Authorize control repo for AWS ([#408](https://github.com/jhatler/janus/issues/408)) ([35e5d4b](https://github.com/jhatler/janus/commit/35e5d4b5f2e61d96f4f753cd02effcf857bc72ac)), closes [#407](https://github.com/jhatler/janus/issues/407)
* Integrate runners stack with ssm stack ([#353](https://github.com/jhatler/janus/issues/353)) ([4b723a9](https://github.com/jhatler/janus/commit/4b723a9ff501c02a0afc6ccd9a31d45b3162372e)), closes [#352](https://github.com/jhatler/janus/issues/352)
* Move Admin subnet to own route table and ACL ([#381](https://github.com/jhatler/janus/issues/381)) ([3f8b8a4](https://github.com/jhatler/janus/commit/3f8b8a4a62554ebb0664e9aa6410a6cb7fca2cdc)), closes [#380](https://github.com/jhatler/janus/issues/380)


### Bug Fixes

* Add missing permissions to runners IAM role ([#437](https://github.com/jhatler/janus/issues/437)) ([cec1249](https://github.com/jhatler/janus/commit/cec1249658949bb00fcfa533a9c57019a72495bb)), closes [#436](https://github.com/jhatler/janus/issues/436)
* Add TF_VAR_ prefix to spacelift dep refs ([#313](https://github.com/jhatler/janus/issues/313)) ([6ebd3cb](https://github.com/jhatler/janus/commit/6ebd3cb7239cc8580259226e6bdd96236e112f2e)), closes [#312](https://github.com/jhatler/janus/issues/312)
* Allow lambda to pass runners roles ([#374](https://github.com/jhatler/janus/issues/374)) ([031afd3](https://github.com/jhatler/janus/commit/031afd3072e024937ea3f8b4f178f7b550ca8df3)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Allow passing apigateway and webhook roles ([#339](https://github.com/jhatler/janus/issues/339)) ([b001444](https://github.com/jhatler/janus/commit/b001444e1f03c8d2f90b6d08fd2f5cdb2fdaefe5)), closes [#338](https://github.com/jhatler/janus/issues/338)
* Allow runner-controlled instances SSM access ([#376](https://github.com/jhatler/janus/issues/376)) ([aa2b86f](https://github.com/jhatler/janus/commit/aa2b86f23e87015edc94584252aefbd35ff37e79)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Correct sid values for network resources ([#319](https://github.com/jhatler/janus/issues/319)) ([6b2b380](https://github.com/jhatler/janus/commit/6b2b3802feb9814ea8a946e1df9f62c076f182e9)), closes [#318](https://github.com/jhatler/janus/issues/318)
* Network IAM configuration ([#327](https://github.com/jhatler/janus/issues/327)) ([04180c5](https://github.com/jhatler/janus/commit/04180c53c4576c7b197bb7219b7c38495231e5f1)), closes [#326](https://github.com/jhatler/janus/issues/326)
* Pass KMS key to runners stack ([#335](https://github.com/jhatler/janus/issues/335)) ([d46c0ea](https://github.com/jhatler/janus/commit/d46c0ea0db64288dc97982caac238bb1322f593d)), closes [#334](https://github.com/jhatler/janus/issues/334)
* Remove alias from AWS provider ([#295](https://github.com/jhatler/janus/issues/295)) ([a88260c](https://github.com/jhatler/janus/commit/a88260c38541b48d7f5c76dc28eabaac02a07dc0)), closes [#282](https://github.com/jhatler/janus/issues/282)
* Remove apigateway caching ([#341](https://github.com/jhatler/janus/issues/341)) ([787b742](https://github.com/jhatler/janus/commit/787b742dd252d8f59d996f9932d46b40e9fe33b1)), closes [#340](https://github.com/jhatler/janus/issues/340)
* Rename s3 access log logging resource ([#321](https://github.com/jhatler/janus/issues/321)) ([159c888](https://github.com/jhatler/janus/commit/159c88839e9d8803a81a1dde3ce693b838770ca9)), closes [#320](https://github.com/jhatler/janus/issues/320)
* Runner-controlled SSM Session Manager Access ([#377](https://github.com/jhatler/janus/issues/377)) ([fe2d0c7](https://github.com/jhatler/janus/commit/fe2d0c72b8497ccc663a59b3dc282edb315d4c34)), closes [#362](https://github.com/jhatler/janus/issues/362)
* S3 access log versions expire after 30 days ([#297](https://github.com/jhatler/janus/issues/297)) ([893c8eb](https://github.com/jhatler/janus/commit/893c8eb0628b5b8b5dbfe18e0b61b1cd23999a9d)), closes [#296](https://github.com/jhatler/janus/issues/296)
* Update network ACLs to use dynamic subnets ([#325](https://github.com/jhatler/janus/issues/325)) ([b17688d](https://github.com/jhatler/janus/commit/b17688d252812f2b8404361acce7b038eb4030a4)), closes [#324](https://github.com/jhatler/janus/issues/324)
* Update runners/webhooks/ssm crypto access ([#375](https://github.com/jhatler/janus/issues/375)) ([d3f8c1e](https://github.com/jhatler/janus/commit/d3f8c1e8585f59677c74e97f7d45eb4dadb98a44)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Use NAT for DMZ and Internal subnets ([#345](https://github.com/jhatler/janus/issues/345)) ([d128861](https://github.com/jhatler/janus/commit/d128861c20e6963b074b3dd128f5c21346ea970e)), closes [#344](https://github.com/jhatler/janus/issues/344)


### Miscellaneous Chores

* **deps:** Bump hashicorp/aws in /terraform/stacks/admin ([#309](https://github.com/jhatler/janus/issues/309)) ([9b520ed](https://github.com/jhatler/janus/commit/9b520edd7bf2082857c95382ff7b1a89a67b1176))
* **deps:** Bump hashicorp/aws in /terraform/stacks/network ([#303](https://github.com/jhatler/janus/issues/303)) ([e87406c](https://github.com/jhatler/janus/commit/e87406ca079a9dedd39429d39483461fe19f50ea))
* **deps:** Update runner-template to v0.2.1 ([#382](https://github.com/jhatler/janus/issues/382)) ([91d9e45](https://github.com/jhatler/janus/commit/91d9e45be4ccc1d5841b3c6bcff5d7bd50119f66))
* **deps:** Update terraform aws to v5.56.1 ([#281](https://github.com/jhatler/janus/issues/281)) ([bd2e90b](https://github.com/jhatler/janus/commit/bd2e90b01f4f3c777291306df80bcf94f6d1e4bd))
* **deps:** Update terraform aws to v5.57.0 ([#386](https://github.com/jhatler/janus/issues/386)) ([9053463](https://github.com/jhatler/janus/commit/9053463e61e5f00c0515e81e9a64ee0cd06cd700))
* **deps:** Update terraform spacelift to v1.14.0 ([#218](https://github.com/jhatler/janus/issues/218)) ([e2a9c56](https://github.com/jhatler/janus/commit/e2a9c5685f7a5389d7e74d86acd03deba53face4))
* Move ubuntu-cloudimg containers to ECR ([#410](https://github.com/jhatler/janus/issues/410)) ([2f69d2e](https://github.com/jhatler/janus/commit/2f69d2ec323aef6f01bb07d947e14670a5f2f69f)), closes [#406](https://github.com/jhatler/janus/issues/406)

## 0.1.0 (2024-05-31)


### Features

* Add initial terraform/spacelift support ([#49](https://github.com/jhatler/janus/issues/49)) ([11370b7](https://github.com/jhatler/janus/commit/11370b74b8147df6496e3b807b1a78c7b3226164)), closes [#46](https://github.com/jhatler/janus/issues/46)
* Give terraform resources their own releases ([#192](https://github.com/jhatler/janus/issues/192)) ([714b460](https://github.com/jhatler/janus/commit/714b460ecab22fd131651d12462b29b3ef115614)), closes [#183](https://github.com/jhatler/janus/issues/183)


### Miscellaneous Chores

* **deps:** Update dependency @types/sinon to v10.0.20 ([#69](https://github.com/jhatler/janus/issues/69)) ([4754d30](https://github.com/jhatler/janus/commit/4754d304a80c7f2de2a5015fbcb74f6edfb69843))
* Initial empty commit ([0fd3265](https://github.com/jhatler/janus/commit/0fd32650d56b8bd4b5c12a74ab41f6da4b6ad26b))
