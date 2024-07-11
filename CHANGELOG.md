# Just Another Neural Utility System Changelog
<!--- @generated --->


## [0.1.6](https://github.com/jhatler/janus/compare/janus-v0.1.5...janus-v0.1.6) (2024-07-11)


### Features

* Actions agent setup by ansible on runners ([#373](https://github.com/jhatler/janus/issues/373)) ([b6e9107](https://github.com/jhatler/janus/commit/b6e9107c896b811a549dc1d750afaa6e5be25809)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add admin Spacelift stack ([#294](https://github.com/jhatler/janus/issues/294)) ([5d54b46](https://github.com/jhatler/janus/commit/5d54b463c3cfd5733afd79fe2f56dfdac554f1c2)), closes [#292](https://github.com/jhatler/janus/issues/292)
* Add ansible support for Packer runner AMIs ([#276](https://github.com/jhatler/janus/issues/276)) ([e0dc8c3](https://github.com/jhatler/janus/commit/e0dc8c3e5be51d495c58b65949f5aae32565815c)), closes [#275](https://github.com/jhatler/janus/issues/275)
* Add auth and crypto stacks ([#317](https://github.com/jhatler/janus/issues/317)) ([0ce4dda](https://github.com/jhatler/janus/commit/0ce4ddac0f938ccf996468c3c564c6646fbbe4f4))
* Add CHANGELOG/README/Tests to github_oidc ([#308](https://github.com/jhatler/janus/issues/308)) ([0d373c3](https://github.com/jhatler/janus/commit/0d373c3d32339b491e8b4cbaca158bcfcd00f3ea)), closes [#300](https://github.com/jhatler/janus/issues/300)
* Add Dockerfile sources for Ubuntu cloudimgs ([#397](https://github.com/jhatler/janus/issues/397)) ([2fab456](https://github.com/jhatler/janus/commit/2fab456fbd0f678038464038b3dfbbc691dc08dd)), closes [#387](https://github.com/jhatler/janus/issues/387)
* Add ecr repository for webhooks ([#363](https://github.com/jhatler/janus/issues/363)) ([85f1a8e](https://github.com/jhatler/janus/commit/85f1a8e7b5701c738d809fccd3cc0aadc294d850)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add GitHub OIDC Terraform Module ([#289](https://github.com/jhatler/janus/issues/289)) ([bc9a3b7](https://github.com/jhatler/janus/commit/bc9a3b70f35af31b527b68d36f7cd83967ed94bd)), closes [#288](https://github.com/jhatler/janus/issues/288)
* Add github-webhook container use by lambda ([#393](https://github.com/jhatler/janus/issues/393)) ([197e756](https://github.com/jhatler/janus/commit/197e756e23767f7f333f782038f9715cd95886b2)), closes [#392](https://github.com/jhatler/janus/issues/392)
* Add network stack ([#291](https://github.com/jhatler/janus/issues/291)) ([47eef0d](https://github.com/jhatler/janus/commit/47eef0dad11ebb36fb2740dda4dc1dcc1d0b359d)), closes [#290](https://github.com/jhatler/janus/issues/290)
* Add packer to build runner AMI ([#274](https://github.com/jhatler/janus/issues/274)) ([b84d54b](https://github.com/jhatler/janus/commit/b84d54bfdd4e93c4d8ba43ea829f359bcbd2466b)), closes [#273](https://github.com/jhatler/janus/issues/273)
* Add runner roles and webhook lambda ([#364](https://github.com/jhatler/janus/issues/364)) ([246ccb4](https://github.com/jhatler/janus/commit/246ccb48ac3dc20dc481777203035dee3ba9152d)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add runner-template stack ([#368](https://github.com/jhatler/janus/issues/368)) ([3192725](https://github.com/jhatler/janus/commit/319272549dd20172e3d85444ff34823b6b63a0e9)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add runners stack to Spacelift ([#333](https://github.com/jhatler/janus/issues/333)) ([3ffcc9e](https://github.com/jhatler/janus/commit/3ffcc9e2869812d36142d7adc4df96a357eeeedd)), closes [#278](https://github.com/jhatler/janus/issues/278)
* Add scratch container ([#389](https://github.com/jhatler/janus/issues/389)) ([5229dc8](https://github.com/jhatler/janus/commit/5229dc8136f915e6ef1843c35eb440424b8698c6)), closes [#388](https://github.com/jhatler/janus/issues/388)
* Add ssm Spacelift stack ([#351](https://github.com/jhatler/janus/issues/351)) ([7fa380d](https://github.com/jhatler/janus/commit/7fa380dc2557cf3d26c58ab8e431f40666ccde21)), closes [#349](https://github.com/jhatler/janus/issues/349)
* Add stack for receiving webhooks ([#337](https://github.com/jhatler/janus/issues/337)) ([87ae708](https://github.com/jhatler/janus/commit/87ae708a68901faa6bdd4f5f3f4bea33b70f9818)), closes [#336](https://github.com/jhatler/janus/issues/336)
* Add stacks for ECR access ([#409](https://github.com/jhatler/janus/issues/409)) ([e7ae358](https://github.com/jhatler/janus/commit/e7ae35858383908f0938fdc6d05328937c0aa974)), closes [#406](https://github.com/jhatler/janus/issues/406)
* Add ubuntu cloud image support ([#379](https://github.com/jhatler/janus/issues/379)) ([f780f2d](https://github.com/jhatler/janus/commit/f780f2d9eb6e19da9d0b545311de283556029394)), closes [#378](https://github.com/jhatler/janus/issues/378)
* Always trigger stack deps ([#348](https://github.com/jhatler/janus/issues/348)) ([2102e53](https://github.com/jhatler/janus/commit/2102e53d24c47ae5389d3e0227cce4e441d56894)), closes [#347](https://github.com/jhatler/janus/issues/347)
* Authorize control repo for AWS ([#408](https://github.com/jhatler/janus/issues/408)) ([35e5d4b](https://github.com/jhatler/janus/commit/35e5d4b5f2e61d96f4f753cd02effcf857bc72ac)), closes [#407](https://github.com/jhatler/janus/issues/407)
* Bootstrap Janus.js testing ([#405](https://github.com/jhatler/janus/issues/405)) ([14fa93e](https://github.com/jhatler/janus/commit/14fa93e28b32a87cd25aca07580a21747e5a8a87)), closes [#171](https://github.com/jhatler/janus/issues/171)
* Bootstrap pyJanus testing ([#400](https://github.com/jhatler/janus/issues/400)) ([bbdb36e](https://github.com/jhatler/janus/commit/bbdb36e4a217b4e2beca13c1909a494200d4213a)), closes [#172](https://github.com/jhatler/janus/issues/172)
* Integrate runners stack with ssm stack ([#353](https://github.com/jhatler/janus/issues/353)) ([4b723a9](https://github.com/jhatler/janus/commit/4b723a9ff501c02a0afc6ccd9a31d45b3162372e)), closes [#352](https://github.com/jhatler/janus/issues/352)
* Move Admin subnet to own route table and ACL ([#381](https://github.com/jhatler/janus/issues/381)) ([3f8b8a4](https://github.com/jhatler/janus/commit/3f8b8a4a62554ebb0664e9aa6410a6cb7fca2cdc)), closes [#380](https://github.com/jhatler/janus/issues/380)
* Parameterize packer network settings ([#435](https://github.com/jhatler/janus/issues/435)) ([bd7ede9](https://github.com/jhatler/janus/commit/bd7ede94193473b380c6f4cf471bbac8fd06cd96)), closes [#434](https://github.com/jhatler/janus/issues/434)
* Spacelift AWS integrations are self-managed ([#280](https://github.com/jhatler/janus/issues/280)) ([a7f4953](https://github.com/jhatler/janus/commit/a7f49537aebf06916de5952326e92dd172d48ad2)), closes [#279](https://github.com/jhatler/janus/issues/279)
* Spacelift stack dependencies ([#299](https://github.com/jhatler/janus/issues/299)) ([571cd67](https://github.com/jhatler/janus/commit/571cd67e83f2619d50037f3576d1c78d29f22aa2)), closes [#298](https://github.com/jhatler/janus/issues/298)
* Ubuntu cloud images repository_dispatch ([#427](https://github.com/jhatler/janus/issues/427)) ([4ece0e2](https://github.com/jhatler/janus/commit/4ece0e232dc89dfc35fd646fa7ca3c146e501f3e)), closes [#426](https://github.com/jhatler/janus/issues/426)


### Bug Fixes

* Add crypto stack as a network dependency ([#323](https://github.com/jhatler/janus/issues/323)) ([2f27653](https://github.com/jhatler/janus/commit/2f2765384ed569bc325acd3f2583c0baa9affe97)), closes [#322](https://github.com/jhatler/janus/issues/322)
* Add missing permissions to runners IAM role ([#437](https://github.com/jhatler/janus/issues/437)) ([cec1249](https://github.com/jhatler/janus/commit/cec1249658949bb00fcfa533a9c57019a72495bb)), closes [#436](https://github.com/jhatler/janus/issues/436)
* Add TF_VAR_ prefix to spacelift dep refs ([#313](https://github.com/jhatler/janus/issues/313)) ([6ebd3cb](https://github.com/jhatler/janus/commit/6ebd3cb7239cc8580259226e6bdd96236e112f2e)), closes [#312](https://github.com/jhatler/janus/issues/312)
* Allow lambda to pass runners roles ([#374](https://github.com/jhatler/janus/issues/374)) ([031afd3](https://github.com/jhatler/janus/commit/031afd3072e024937ea3f8b4f178f7b550ca8df3)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Allow passing apigateway and webhook roles ([#339](https://github.com/jhatler/janus/issues/339)) ([b001444](https://github.com/jhatler/janus/commit/b001444e1f03c8d2f90b6d08fd2f5cdb2fdaefe5)), closes [#338](https://github.com/jhatler/janus/issues/338)
* Allow runner-controlled instances SSM access ([#376](https://github.com/jhatler/janus/issues/376)) ([aa2b86f](https://github.com/jhatler/janus/commit/aa2b86f23e87015edc94584252aefbd35ff37e79)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Apply cloud integrations after stack create ([#287](https://github.com/jhatler/janus/issues/287)) ([3f21ff4](https://github.com/jhatler/janus/commit/3f21ff425392a61fa1799e3012e72df28829f8e1)), closes [#286](https://github.com/jhatler/janus/issues/286)
* Correct sid values for network resources ([#319](https://github.com/jhatler/janus/issues/319)) ([6b2b380](https://github.com/jhatler/janus/commit/6b2b3802feb9814ea8a946e1df9f62c076f182e9)), closes [#318](https://github.com/jhatler/janus/issues/318)
* Network IAM configuration ([#327](https://github.com/jhatler/janus/issues/327)) ([04180c5](https://github.com/jhatler/janus/commit/04180c53c4576c7b197bb7219b7c38495231e5f1)), closes [#326](https://github.com/jhatler/janus/issues/326)
* Output stack id instead of ARN ([#332](https://github.com/jhatler/janus/issues/332)) ([f7d8edc](https://github.com/jhatler/janus/commit/f7d8edc72494b350b22557fd83db4236c8320811)), closes [#331](https://github.com/jhatler/janus/issues/331)
* Pass KMS key to runners stack ([#335](https://github.com/jhatler/janus/issues/335)) ([d46c0ea](https://github.com/jhatler/janus/commit/d46c0ea0db64288dc97982caac238bb1322f593d)), closes [#334](https://github.com/jhatler/janus/issues/334)
* Pass stack role to auth stack as input ([#330](https://github.com/jhatler/janus/issues/330)) ([eefbfef](https://github.com/jhatler/janus/commit/eefbfef748d5086aa822cf3e62c3cbb748fb3abb)), closes [#329](https://github.com/jhatler/janus/issues/329)
* Pre-16.10 ubuntu blocklist fixes ([#384](https://github.com/jhatler/janus/issues/384)) ([4988a43](https://github.com/jhatler/janus/commit/4988a437a878c65af7ca0405a755bdd089e7cd2c)), closes [#383](https://github.com/jhatler/janus/issues/383)
* Publish arm64 containers during release ([#204](https://github.com/jhatler/janus/issues/204)) ([d7f2738](https://github.com/jhatler/janus/commit/d7f273823f5da8ae7b0efdbcc8cbcaa0ea0fda86)), closes [#203](https://github.com/jhatler/janus/issues/203)
* Refactor sts external id creation ([#361](https://github.com/jhatler/janus/issues/361)) ([152ed62](https://github.com/jhatler/janus/commit/152ed627033bbbd5007f1511e8583e2f7944e886)), closes [#359](https://github.com/jhatler/janus/issues/359)
* Remove alias from AWS provider ([#283](https://github.com/jhatler/janus/issues/283)) ([6929f46](https://github.com/jhatler/janus/commit/6929f46954e104b352a534e2ae533599bf659c4a)), closes [#282](https://github.com/jhatler/janus/issues/282)
* Remove alias from AWS provider ([#295](https://github.com/jhatler/janus/issues/295)) ([a88260c](https://github.com/jhatler/janus/commit/a88260c38541b48d7f5c76dc28eabaac02a07dc0)), closes [#282](https://github.com/jhatler/janus/issues/282)
* Remove apigateway caching ([#341](https://github.com/jhatler/janus/issues/341)) ([787b742](https://github.com/jhatler/janus/commit/787b742dd252d8f59d996f9932d46b40e9fe33b1)), closes [#340](https://github.com/jhatler/janus/issues/340)
* Rename s3 access log logging resource ([#321](https://github.com/jhatler/janus/issues/321)) ([159c888](https://github.com/jhatler/janus/commit/159c88839e9d8803a81a1dde3ce693b838770ca9)), closes [#320](https://github.com/jhatler/janus/issues/320)
* Runner-controlled SSM Session Manager Access ([#377](https://github.com/jhatler/janus/issues/377)) ([fe2d0c7](https://github.com/jhatler/janus/commit/fe2d0c72b8497ccc663a59b3dc282edb315d4c34)), closes [#362](https://github.com/jhatler/janus/issues/362)
* S3 access log versions expire after 30 days ([#297](https://github.com/jhatler/janus/issues/297)) ([893c8eb](https://github.com/jhatler/janus/commit/893c8eb0628b5b8b5dbfe18e0b61b1cd23999a9d)), closes [#296](https://github.com/jhatler/janus/issues/296)
* Spacelift determines control repo via context ([#285](https://github.com/jhatler/janus/issues/285)) ([b9ee3d5](https://github.com/jhatler/janus/commit/b9ee3d5dc209dfa943c426f5f94bb367c755caca)), closes [#284](https://github.com/jhatler/janus/issues/284)
* Update network ACLs to use dynamic subnets ([#325](https://github.com/jhatler/janus/issues/325)) ([b17688d](https://github.com/jhatler/janus/commit/b17688d252812f2b8404361acce7b038eb4030a4)), closes [#324](https://github.com/jhatler/janus/issues/324)
* Update runners/webhooks/ssm crypto access ([#375](https://github.com/jhatler/janus/issues/375)) ([d3f8c1e](https://github.com/jhatler/janus/commit/d3f8c1e8585f59677c74e97f7d45eb4dadb98a44)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Update secrets in ubuntu cloud image workflow ([#433](https://github.com/jhatler/janus/issues/433)) ([22acb93](https://github.com/jhatler/janus/commit/22acb93f1b2f2bab09b85a5e17de7bb7ea89336e)), closes [#432](https://github.com/jhatler/janus/issues/432)
* Use module slug for aws integration ([#360](https://github.com/jhatler/janus/issues/360)) ([10c40ac](https://github.com/jhatler/janus/commit/10c40aca5f0ae52ea24b90efa51636f061b55f50)), closes [#359](https://github.com/jhatler/janus/issues/359)
* Use NAT for DMZ and Internal subnets ([#345](https://github.com/jhatler/janus/issues/345)) ([d128861](https://github.com/jhatler/janus/commit/d128861c20e6963b074b3dd128f5c21346ea970e)), closes [#344](https://github.com/jhatler/janus/issues/344)


### Miscellaneous Chores

* Add vscode settings for ansible ([#399](https://github.com/jhatler/janus/issues/399)) ([c1f17ec](https://github.com/jhatler/janus/commit/c1f17ec763084f98bd5ef5c14cb7ff02a353da41)), closes [#398](https://github.com/jhatler/janus/issues/398)
* Bump runner-template module version ([#371](https://github.com/jhatler/janus/issues/371)) ([fb8912e](https://github.com/jhatler/janus/commit/fb8912e9c9a398eb1097f16bf853c35cc5efbc24)), closes [#362](https://github.com/jhatler/janus/issues/362)
* **deps-dev:** Bump @types/node from 20.13.0 to 20.14.0 ([#213](https://github.com/jhatler/janus/issues/213)) ([5c39c6d](https://github.com/jhatler/janus/commit/5c39c6d275bc95c09a7896469e5d18675d80b658))
* **deps-dev:** Bump @types/node from 20.14.0 to 20.14.2 ([#237](https://github.com/jhatler/janus/issues/237)) ([33c7d49](https://github.com/jhatler/janus/commit/33c7d4913ce47bac4e099023024909b6996a5da8))
* **deps-dev:** Bump @types/node from 20.14.2 to 20.14.8 ([#269](https://github.com/jhatler/janus/issues/269)) ([c07ec1c](https://github.com/jhatler/janus/commit/c07ec1cc8f241f5009e4fa0d5ea14807f19ab4f5))
* **deps-dev:** Bump gts from 5.3.0 to 5.3.1 ([#255](https://github.com/jhatler/janus/issues/255)) ([626ea80](https://github.com/jhatler/janus/commit/626ea80033398a06331879a41b9cea0ec1269342))
* **deps-dev:** Bump mocha from 10.5.1 to 10.5.2 ([#358](https://github.com/jhatler/janus/issues/358)) ([c3ccdf5](https://github.com/jhatler/janus/commit/c3ccdf5679718e792dd48b708d797c07fd9119fe))
* **deps:** Bump @grpc/grpc-js in the npm_and_yarn group ([#242](https://github.com/jhatler/janus/issues/242)) ([62edb21](https://github.com/jhatler/janus/commit/62edb214e3fb4f50aa6f4b4029e4565323b757df))
* **deps:** Bump boto3 from 1.34.131 to 1.34.132 in /lib/pyjanus ([#304](https://github.com/jhatler/janus/issues/304)) ([e832292](https://github.com/jhatler/janus/commit/e832292243145b7764630919946ea7cee9121367))
* **deps:** Bump boto3 from 1.34.133 to 1.34.136 in /lib/pyjanus ([#369](https://github.com/jhatler/janus/issues/369)) ([7755510](https://github.com/jhatler/janus/commit/77555101dd995ae82150a0391fc1fc52e3eee290))
* **deps:** Bump boto3 from 1.34.136 to 1.34.137 in /lib/pyjanus ([#372](https://github.com/jhatler/janus/issues/372)) ([156e81b](https://github.com/jhatler/janus/commit/156e81b6e6058bb882bb4853aad2e76c70f53da5))
* **deps:** Bump boto3 from 1.34.139 to 1.34.143 in /lib/pyjanus ([#431](https://github.com/jhatler/janus/issues/431)) ([e48a28f](https://github.com/jhatler/janus/commit/e48a28fbd05c89c6cd20788cca90c5d9bd846601))
* **deps:** Bump google-api-python-client in /lib/pyjanus ([#355](https://github.com/jhatler/janus/issues/355)) ([8863bfb](https://github.com/jhatler/janus/commit/8863bfb6d1e60c9faab415219e85cc57fe3a0747))
* **deps:** Bump hashicorp/aws in /terraform/control ([#302](https://github.com/jhatler/janus/issues/302)) ([5c69c2a](https://github.com/jhatler/janus/commit/5c69c2ae98f048ec02bda25a02d984f590cf537c))
* **deps:** Bump hashicorp/aws in /terraform/modules/github_oidc ([#310](https://github.com/jhatler/janus/issues/310)) ([b915474](https://github.com/jhatler/janus/commit/b91547492238d6f00c43c41533e902dcfad99339))
* **deps:** Bump hashicorp/aws in /terraform/stacks/admin ([#309](https://github.com/jhatler/janus/issues/309)) ([9b520ed](https://github.com/jhatler/janus/commit/9b520edd7bf2082857c95382ff7b1a89a67b1176))
* **deps:** Bump hashicorp/aws in /terraform/stacks/network ([#303](https://github.com/jhatler/janus/issues/303)) ([e87406c](https://github.com/jhatler/janus/commit/e87406ca079a9dedd39429d39483461fe19f50ea))
* **deps:** Bump openai from 1.35.4 to 1.35.7 in /lib/pyjanus ([#354](https://github.com/jhatler/janus/issues/354)) ([f530c07](https://github.com/jhatler/janus/commit/f530c07a472e3f3cd1b14bb65d4eec0b527377ae))
* **deps:** Bump urllib3 ([#260](https://github.com/jhatler/janus/issues/260)) ([24e1921](https://github.com/jhatler/janus/commit/24e192158b99200dc978cebad2f961bb24bb3ad0))
* **deps:** Update actions/checkout action to v4.1.7 ([#247](https://github.com/jhatler/janus/issues/247)) ([d1bdad5](https://github.com/jhatler/janus/commit/d1bdad524a73cd501d5071f21aed614332bfdb67))
* **deps:** Update dependency @types/mocha to v10.0.7 ([#267](https://github.com/jhatler/janus/issues/267)) ([7aa9e09](https://github.com/jhatler/janus/commit/7aa9e0982f6311c69a97aa4508f72a3c2739a77b))
* **deps:** Update dependency boto3 to v1.34.118 ([#219](https://github.com/jhatler/janus/issues/219)) ([0238e1a](https://github.com/jhatler/janus/commit/0238e1a97e003475c70552e0052a53b4d2547251))
* **deps:** Update dependency boto3 to v1.34.119 ([#225](https://github.com/jhatler/janus/issues/225)) ([95d9898](https://github.com/jhatler/janus/commit/95d9898ca1b81b70453142676cd021b84bf71b8c))
* **deps:** Update dependency boto3 to v1.34.120 ([#228](https://github.com/jhatler/janus/issues/228)) ([d02a730](https://github.com/jhatler/janus/commit/d02a73064618cd6f8120cc1292121ff96a6460c6))
* **deps:** Update dependency boto3 to v1.34.121 ([#230](https://github.com/jhatler/janus/issues/230)) ([aba5f1b](https://github.com/jhatler/janus/commit/aba5f1ba0b4b840d08b6acdb956351034b796077))
* **deps:** Update dependency boto3 to v1.34.122 ([#233](https://github.com/jhatler/janus/issues/233)) ([30e9a5a](https://github.com/jhatler/janus/commit/30e9a5a2e2f144d80ec2a36ae2230993dcc6c43c))
* **deps:** Update dependency boto3 to v1.34.123 ([#241](https://github.com/jhatler/janus/issues/241)) ([74b4bf1](https://github.com/jhatler/janus/commit/74b4bf15bdcea359d4158c2cf47eddad2034d40c))
* **deps:** Update dependency boto3 to v1.34.125 ([#244](https://github.com/jhatler/janus/issues/244)) ([282f745](https://github.com/jhatler/janus/commit/282f7455c6f8a30d3279051d463a37ce937d0dbd))
* **deps:** Update dependency boto3 to v1.34.126 ([#250](https://github.com/jhatler/janus/issues/250)) ([20d2b37](https://github.com/jhatler/janus/commit/20d2b37ef21c958b45416813e7a3a6439c68d0c6))
* **deps:** Update dependency boto3 to v1.34.127 ([#251](https://github.com/jhatler/janus/issues/251)) ([644eab6](https://github.com/jhatler/janus/commit/644eab6f0dc3ad05ca91a28c522988a71227240c))
* **deps:** Update dependency boto3 to v1.34.131 ([#259](https://github.com/jhatler/janus/issues/259)) ([57c6fcb](https://github.com/jhatler/janus/commit/57c6fcb78e4d67ab1d7c0c178ab87cdd01f58a12))
* **deps:** Update dependency boto3 to v1.34.133 ([#272](https://github.com/jhatler/janus/issues/272)) ([24a2470](https://github.com/jhatler/janus/commit/24a247090a030a6b388ddcd70368a7fae97135fe))
* **deps:** Update dependency boto3 to v1.34.139 ([#346](https://github.com/jhatler/janus/issues/346)) ([2c2b4d2](https://github.com/jhatler/janus/commit/2c2b4d2e80893147c9a600598649f65b5f8405b8))
* **deps:** Update dependency certifi to v2024.6.2 ([#212](https://github.com/jhatler/janus/issues/212)) ([16f3e46](https://github.com/jhatler/janus/commit/16f3e463b5ac9eb0f9207e7cb1a98ac78c3a2453))
* **deps:** Update dependency certifi to v2024.7.4 ([#385](https://github.com/jhatler/janus/issues/385)) ([60413a5](https://github.com/jhatler/janus/commit/60413a5be90ed3b828472cf49b9b00626c7514df))
* **deps:** Update dependency click to v8.1.7 ([#268](https://github.com/jhatler/janus/issues/268)) ([96a2b33](https://github.com/jhatler/janus/commit/96a2b339d15f2edae984cde27595ca1539f79def))
* **deps:** Update dependency cryptography to v42.0.8 ([#226](https://github.com/jhatler/janus/issues/226)) ([f506bdd](https://github.com/jhatler/janus/commit/f506bdddc89dfe825643333395f9cdd3da45d193))
* **deps:** Update dependency flake8 to v7.1.0 ([#404](https://github.com/jhatler/janus/issues/404)) ([b5307da](https://github.com/jhatler/janus/commit/b5307da02477d879e965bd7b46fc166dc5522172))
* **deps:** Update dependency google-api-python-client to v2.132.0 ([#223](https://github.com/jhatler/janus/issues/223)) ([34332fc](https://github.com/jhatler/janus/commit/34332fce9239c68d20e9ebbffd13d059725be2e2))
* **deps:** Update dependency google-api-python-client to v2.133.0 ([#243](https://github.com/jhatler/janus/issues/243)) ([084241a](https://github.com/jhatler/janus/commit/084241a086304d85a70b7c15b75481b850f037ec))
* **deps:** Update dependency google-api-python-client to v2.134.0 ([#262](https://github.com/jhatler/janus/issues/262)) ([f05f24d](https://github.com/jhatler/janus/commit/f05f24d7127220a6719e44ecf7f878cc44067abd))
* **deps:** Update dependency google-api-python-client to v2.136.0 ([#350](https://github.com/jhatler/janus/issues/350)) ([2b084d8](https://github.com/jhatler/janus/commit/2b084d8865bda9c1d8f3022277500fab36d3ce95))
* **deps:** Update dependency google-api-python-client to v2.137.0 ([#429](https://github.com/jhatler/janus/issues/429)) ([33dcf74](https://github.com/jhatler/janus/commit/33dcf74222e8e983d471c0fe7cc975dc07a322bb))
* **deps:** Update dependency google-auth to v2.30.0 ([#232](https://github.com/jhatler/janus/issues/232)) ([1db0c79](https://github.com/jhatler/janus/commit/1db0c798219642bde80a894139f3fcfb8bc50184))
* **deps:** Update dependency google-auth to v2.31.0 ([#370](https://github.com/jhatler/janus/issues/370)) ([f3cdbce](https://github.com/jhatler/janus/commit/f3cdbce798328631b65a55357ad2214d52300152))
* **deps:** Update dependency google-auth to v2.32.0 ([#425](https://github.com/jhatler/janus/issues/425)) ([ee97738](https://github.com/jhatler/janus/commit/ee97738299ce9315eda9a1c1ef894ac0ae3eef7b))
* **deps:** Update dependency importlib-metadata to v7.2.1 ([#265](https://github.com/jhatler/janus/issues/265)) ([6b0f9e6](https://github.com/jhatler/janus/commit/6b0f9e69a3a999c2e148a26a2e9cb7260219ca83))
* **deps:** Update dependency importlib-metadata to v8 ([#305](https://github.com/jhatler/janus/issues/305)) ([8d99e56](https://github.com/jhatler/janus/commit/8d99e568495a58c076ce25f6eba699f3de534760))
* **deps:** Update dependency mocha to v10.5.1 ([#271](https://github.com/jhatler/janus/issues/271)) ([d5cc552](https://github.com/jhatler/janus/commit/d5cc552a0262d87a01bf84650bb5ae623c7b1c79))
* **deps:** Update dependency mocha to v10.6.0 ([#342](https://github.com/jhatler/janus/issues/342)) ([377a936](https://github.com/jhatler/janus/commit/377a936948c0b934f272b8b9e35126b215e42e6a))
* **deps:** Update dependency more-itertools to v10.3.0 ([#239](https://github.com/jhatler/janus/issues/239)) ([981a4f2](https://github.com/jhatler/janus/commit/981a4f2a323095439883901299100c103db2531c))
* **deps:** Update dependency openai to v1.31.0 ([#220](https://github.com/jhatler/janus/issues/220)) ([4cd7734](https://github.com/jhatler/janus/commit/4cd773487571d80b4c1375b469af4ae0dc85da33))
* **deps:** Update dependency openai to v1.31.2 ([#227](https://github.com/jhatler/janus/issues/227)) ([684475d](https://github.com/jhatler/janus/commit/684475d06d5f14b65940da4f546a0d2af683c141))
* **deps:** Update dependency openai to v1.32.0 ([#231](https://github.com/jhatler/janus/issues/231)) ([3b5a840](https://github.com/jhatler/janus/commit/3b5a840d728f362ddd8e4247a0a4c0517e1c2860))
* **deps:** Update dependency openai to v1.33.0 ([#234](https://github.com/jhatler/janus/issues/234)) ([d531799](https://github.com/jhatler/janus/commit/d531799e0fd02410afb7fb0d75a63e55f3ad6630))
* **deps:** Update dependency openai to v1.34.0 ([#248](https://github.com/jhatler/janus/issues/248)) ([0b7a9df](https://github.com/jhatler/janus/commit/0b7a9dfbe2e948b11914778195f6cffb71b64174))
* **deps:** Update dependency openai to v1.35.10 ([#343](https://github.com/jhatler/janus/issues/343)) ([2b4ff92](https://github.com/jhatler/janus/commit/2b4ff927f1758b69e2453488232bd3f5758941c7))
* **deps:** Update dependency openai to v1.35.13 ([#428](https://github.com/jhatler/janus/issues/428)) ([c952658](https://github.com/jhatler/janus/commit/c9526580e9a900fffe00e918fa772de677338f7b))
* **deps:** Update dependency openai to v1.35.3 ([#263](https://github.com/jhatler/janus/issues/263)) ([7620737](https://github.com/jhatler/janus/commit/7620737f215f815b222c5ed746a3dccee31db88c))
* **deps:** Update dependency openai to v1.35.4 ([#328](https://github.com/jhatler/janus/issues/328)) ([45861fe](https://github.com/jhatler/janus/commit/45861fe4b8b286578762649a46f6811aed7fad72))
* **deps:** Update dependency packaging to v24.1 ([#235](https://github.com/jhatler/janus/issues/235)) ([4a8df3f](https://github.com/jhatler/janus/commit/4a8df3fe3c74972df9d72453d412f1235eebb129))
* **deps:** Update dependency pip to v24.1.2 ([#416](https://github.com/jhatler/janus/issues/416)) ([e6fd788](https://github.com/jhatler/janus/commit/e6fd788a38584add6114b3f3d7f64234036aa884))
* **deps:** Update dependency protobuf to v5.27.1 ([#229](https://github.com/jhatler/janus/issues/229)) ([6b3677f](https://github.com/jhatler/janus/commit/6b3677ffcc045149a94e2910966ba4ea9a0a12cd))
* **deps:** Update dependency protobuf to v5.27.2 ([#315](https://github.com/jhatler/janus/issues/315)) ([79cbaf3](https://github.com/jhatler/janus/commit/79cbaf39887c299faded0c1e87e64aa00dd2f5a0))
* **deps:** Update dependency pylint to v3.2.5 ([#395](https://github.com/jhatler/janus/issues/395)) ([6c2329c](https://github.com/jhatler/janus/commit/6c2329c9b901065133f08fd8445a848dbeee3fb6))
* **deps:** Update dependency pyperclip to v1.9.0 ([#264](https://github.com/jhatler/janus/issues/264)) ([056da94](https://github.com/jhatler/janus/commit/056da94b0bcd2e551d36192cc6be91020924fabe))
* **deps:** Update dependency pyright to v1.1.370 ([#396](https://github.com/jhatler/janus/issues/396)) ([1928bc3](https://github.com/jhatler/janus/commit/1928bc3ffcfe2bc964cfd272547ed823d1b5f8cc))
* **deps:** Update dependency pyright to v1.1.371 ([#430](https://github.com/jhatler/janus/issues/430)) ([58f3208](https://github.com/jhatler/janus/commit/58f320822260691a9f34a8443f805a151c00158b))
* **deps:** Update dependency pytest to v8.2.2 ([#403](https://github.com/jhatler/janus/issues/403)) ([c8c1e07](https://github.com/jhatler/janus/commit/c8c1e07bd20c9f097d6d3e10277e37c8b13fb577))
* **deps:** Update dependency zipp to v3.19.2 ([#224](https://github.com/jhatler/janus/issues/224)) ([6cb6488](https://github.com/jhatler/janus/commit/6cb6488bc44b6c1964e09654d982814082db3987))
* **deps:** Update github/codeql-action action to v3.25.10 ([#249](https://github.com/jhatler/janus/issues/249)) ([94799a8](https://github.com/jhatler/janus/commit/94799a8d9c03d45ab9cecdadb91cdf85cbd1c17b))
* **deps:** Update github/codeql-action action to v3.25.11 ([#365](https://github.com/jhatler/janus/issues/365)) ([17e665e](https://github.com/jhatler/janus/commit/17e665ef1973eb6dc531684e9261422e18ba25ca))
* **deps:** Update github/codeql-action action to v3.25.8 ([#222](https://github.com/jhatler/janus/issues/222)) ([97d1a53](https://github.com/jhatler/janus/commit/97d1a53d490285896806dde18e9e950afd52c75d))
* **deps:** Update github/codeql-action action to v3.25.9 ([#246](https://github.com/jhatler/janus/issues/246)) ([0d46a57](https://github.com/jhatler/janus/commit/0d46a57b6499d1cf686035c855f2ec56827d6480))
* **deps:** Update runner-template to v0.2.1 ([#382](https://github.com/jhatler/janus/issues/382)) ([91d9e45](https://github.com/jhatler/janus/commit/91d9e45be4ccc1d5841b3c6bcff5d7bd50119f66))
* **deps:** Update super-linter/super-linter action to v6.6.0 ([#221](https://github.com/jhatler/janus/issues/221)) ([3cecc28](https://github.com/jhatler/janus/commit/3cecc28f9b8d2225b8a62652a0c75c69f2199e9c))
* **deps:** Update terraform aws to v5.56.1 ([#281](https://github.com/jhatler/janus/issues/281)) ([bd2e90b](https://github.com/jhatler/janus/commit/bd2e90b01f4f3c777291306df80bcf94f6d1e4bd))
* **deps:** Update terraform aws to v5.57.0 ([#386](https://github.com/jhatler/janus/issues/386)) ([9053463](https://github.com/jhatler/janus/commit/9053463e61e5f00c0515e81e9a64ee0cd06cd700))
* **deps:** Update terraform aws to v5.57.0 ([#394](https://github.com/jhatler/janus/issues/394)) ([536c31a](https://github.com/jhatler/janus/commit/536c31a3259b40b4b4c9c282ad27420f3bc3b8f9))
* **deps:** Update terraform spacelift to v1.14.0 ([#218](https://github.com/jhatler/janus/issues/218)) ([e2a9c56](https://github.com/jhatler/janus/commit/e2a9c5685f7a5389d7e74d86acd03deba53face4))
* Migrate to opencontainer labels ([#208](https://github.com/jhatler/janus/issues/208)) ([fc0d474](https://github.com/jhatler/janus/commit/fc0d474742bc020f2d9fe8a7ac4541186d5587c4)), closes [#207](https://github.com/jhatler/janus/issues/207) [#203](https://github.com/jhatler/janus/issues/203)
* Move janus devcontainer to container root ([#391](https://github.com/jhatler/janus/issues/391)) ([a828428](https://github.com/jhatler/janus/commit/a8284285dc8704e366733a8c0d7bd6e0c293beef)), closes [#390](https://github.com/jhatler/janus/issues/390)
* Move ubuntu-cloudimg containers to ECR ([#410](https://github.com/jhatler/janus/issues/410)) ([2f69d2e](https://github.com/jhatler/janus/commit/2f69d2ec323aef6f01bb07d947e14670a5f2f69f)), closes [#406](https://github.com/jhatler/janus/issues/406)

## [0.1.5](https://github.com/jhatler/janus/compare/janus-v0.1.4...janus-v0.1.5) (2024-05-31)


### Features

* Add aikido security workflow ([#67](https://github.com/jhatler/janus/issues/67)) ([4f9d6b2](https://github.com/jhatler/janus/commit/4f9d6b200e0f3404676d7973d07d2a7d9951c777)), closes [#55](https://github.com/jhatler/janus/issues/55)
* Add badges and Index to README ([#160](https://github.com/jhatler/janus/issues/160)) ([e12c993](https://github.com/jhatler/janus/commit/e12c99302ef842ac22a11f2744e2203ea6cb12cb)), closes [#154](https://github.com/jhatler/janus/issues/154)
* Add codacy config file ([#196](https://github.com/jhatler/janus/issues/196)) ([433468a](https://github.com/jhatler/janus/commit/433468a7cfc0e6998d86818ec80bdadfacdd35fd)), closes [#195](https://github.com/jhatler/janus/issues/195)
* Add initial terraform/spacelift support ([#49](https://github.com/jhatler/janus/issues/49)) ([11370b7](https://github.com/jhatler/janus/commit/11370b74b8147df6496e3b807b1a78c7b3226164)), closes [#46](https://github.com/jhatler/janus/issues/46)
* Add OpenSSF Best Practices badge to README ([#177](https://github.com/jhatler/janus/issues/177)) ([a65e9f6](https://github.com/jhatler/janus/commit/a65e9f6764497eae964ec144fb8579c4dac846e8)), closes [#154](https://github.com/jhatler/janus/issues/154)
* Add OSSF Scorecard action ([#157](https://github.com/jhatler/janus/issues/157)) ([4c13aaa](https://github.com/jhatler/janus/commit/4c13aaae773e0b9109273b2fb970c36847b014d4)), closes [#156](https://github.com/jhatler/janus/issues/156)
* Give terraform resources their own releases ([#192](https://github.com/jhatler/janus/issues/192)) ([714b460](https://github.com/jhatler/janus/commit/714b460ecab22fd131651d12462b29b3ef115614)), closes [#183](https://github.com/jhatler/janus/issues/183)
* Sign containers ([#127](https://github.com/jhatler/janus/issues/127)) ([194d03d](https://github.com/jhatler/janus/commit/194d03d08192ec6f25b6fc5b55ac397cee1b68e1)), closes [#126](https://github.com/jhatler/janus/issues/126)
* Update dependabot and tfsec integrations ([#186](https://github.com/jhatler/janus/issues/186)) ([2b6ce97](https://github.com/jhatler/janus/commit/2b6ce97333f5f8681d6bbb71aef22502de5935ed)), closes [#184](https://github.com/jhatler/janus/issues/184)
* Upgrade release-trigger to node 22 ([#136](https://github.com/jhatler/janus/issues/136)) ([0b00c31](https://github.com/jhatler/janus/commit/0b00c31474f6c538491b7bfad247037dfcb4a262)), closes [#130](https://github.com/jhatler/janus/issues/130)
* Use GitHub Action cache in container actions ([#129](https://github.com/jhatler/janus/issues/129)) ([6a1ff6a](https://github.com/jhatler/janus/commit/6a1ff6a5be75d080bc7ec97760fc0a62ff410c1e)), closes [#128](https://github.com/jhatler/janus/issues/128)


### Bug Fixes

* Correct terraform release setup ([#193](https://github.com/jhatler/janus/issues/193)) ([641ceb5](https://github.com/jhatler/janus/commit/641ceb5475de19ab20e84fa7342c79841fac0abf)), closes [#183](https://github.com/jhatler/janus/issues/183)
* **deps:** Update dependency jsonwebtoken to v9.0.2 ([#73](https://github.com/jhatler/janus/issues/73)) ([c5312fa](https://github.com/jhatler/janus/commit/c5312fa5d7f0bd48881eb22b5f1a90ab8abeb160))
* Disable postInstall actions devcontainer test ([#151](https://github.com/jhatler/janus/issues/151)) ([59d510d](https://github.com/jhatler/janus/commit/59d510d81364f3af131a81fe0376894b093a6dfc)), closes [#148](https://github.com/jhatler/janus/issues/148)
* Hello_world spacelift stack is administrative ([#199](https://github.com/jhatler/janus/issues/199)) ([9867022](https://github.com/jhatler/janus/commit/986702276ad7679d851301363b031e02c625377e)), closes [#198](https://github.com/jhatler/janus/issues/198)
* Improve caching for container builds ([#155](https://github.com/jhatler/janus/issues/155)) ([951d667](https://github.com/jhatler/janus/commit/951d667916a751bd726f0e4c234a568ecb50c621)), closes [#153](https://github.com/jhatler/janus/issues/153)
* Mark release-trigger changelog as generated ([#66](https://github.com/jhatler/janus/issues/66)) ([6f6a2aa](https://github.com/jhatler/janus/commit/6f6a2aaf9c609052d4569d0c9d765959481f76d7)), closes [#64](https://github.com/jhatler/janus/issues/64)
* Remove the extra license badge ([#163](https://github.com/jhatler/janus/issues/163)) ([0e75254](https://github.com/jhatler/janus/commit/0e75254c61d2ec00c8ef5d7c06738ec8ac2355b7)), closes [#154](https://github.com/jhatler/janus/issues/154)
* Renamed codacy.tml to codacy.yml ([#197](https://github.com/jhatler/janus/issues/197)) ([e3b4c66](https://github.com/jhatler/janus/commit/e3b4c66e67bd2191dec3f261675f9c8a7e177ee8)), closes [#195](https://github.com/jhatler/janus/issues/195)
* Run release-trigger wf only on relevant PRs ([#162](https://github.com/jhatler/janus/issues/162)) ([53c436f](https://github.com/jhatler/janus/commit/53c436fe912457a90baf451c340688ad1f81e3b2)), closes [#161](https://github.com/jhatler/janus/issues/161)
* Update release-trigger release name ([#65](https://github.com/jhatler/janus/issues/65)) ([996970b](https://github.com/jhatler/janus/commit/996970bef755084e694e189ea60f1ff9023391b7)), closes [#62](https://github.com/jhatler/janus/issues/62)


### Reverts

* Disable codeql and tfsec workflows ([#180](https://github.com/jhatler/janus/issues/180)) ([6938c6e](https://github.com/jhatler/janus/commit/6938c6e47dfd74f4dc2238f740034641e7bbd47d)), closes [#119](https://github.com/jhatler/janus/issues/119)


### Miscellaneous Chores

* **deps-dev:** Bump @types/node from 20.12.13 to 20.13.0 ([#191](https://github.com/jhatler/janus/issues/191)) ([9c95be0](https://github.com/jhatler/janus/commit/9c95be0263f2bdf93ff2d3601391f77761200f1c))
* **deps:** Release-trigger typescript update to 5.2 ([#149](https://github.com/jhatler/janus/issues/149)) ([2a8fa5f](https://github.com/jhatler/janus/commit/2a8fa5f8325955bb6c9dfe9fee44f4712bc6ccf3))
* **deps:** Update actions/cache action to v4 ([#94](https://github.com/jhatler/janus/issues/94)) ([a7a6c52](https://github.com/jhatler/janus/commit/a7a6c52702a52c9f833ec7314ebc438eeb72cb8b))
* **deps:** Update actions/checkout action to v4.1.6 ([#159](https://github.com/jhatler/janus/issues/159)) ([705aa34](https://github.com/jhatler/janus/commit/705aa34b51b0ddd44b5879c85affd8f11f8b0170))
* **deps:** Update actions/upload-artifact action to v4 ([#179](https://github.com/jhatler/janus/issues/179)) ([47aee14](https://github.com/jhatler/janus/commit/47aee14c4f81f4973c8de3399477ef797b2dc2ad))
* **deps:** Update actions/upload-artifact digest to a8a3f3a ([#158](https://github.com/jhatler/janus/issues/158)) ([9645ed7](https://github.com/jhatler/janus/commit/9645ed77d7724ffb07471994f54bcba6617adc7b))
* **deps:** Update dependency @types/node to v18.19.33 ([#74](https://github.com/jhatler/janus/issues/74)) ([84d04c2](https://github.com/jhatler/janus/commit/84d04c221dc217b7239327b840926da8af2494e9))
* **deps:** Update dependency @types/sinon to v10.0.20 ([#69](https://github.com/jhatler/janus/issues/69)) ([4754d30](https://github.com/jhatler/janus/commit/4754d304a80c7f2de2a5015fbcb74f6edfb69843))
* **deps:** Update dependency @types/sinon to v17 ([#95](https://github.com/jhatler/janus/issues/95)) ([0a7413d](https://github.com/jhatler/janus/commit/0a7413d4ff44509b103a8881e0c12641c0e25da6))
* **deps:** Update dependency attrs to v22.2.0 ([#75](https://github.com/jhatler/janus/issues/75)) ([07ef50f](https://github.com/jhatler/janus/commit/07ef50fd4a2bbb44cb6c4f0219557167f8139f75))
* **deps:** Update dependency attrs to v23 ([#96](https://github.com/jhatler/janus/issues/96)) ([5d6285e](https://github.com/jhatler/janus/commit/5d6285e2dcd704089f7f8db582853a9036b28be8))
* **deps:** Update dependency boto3 to v1.34.114 ([#70](https://github.com/jhatler/janus/issues/70)) ([8eafc2a](https://github.com/jhatler/janus/commit/8eafc2a6269c3ac0ee6c0e3744eb29083bdeef91))
* **deps:** Update dependency boto3 to v1.34.116 ([#135](https://github.com/jhatler/janus/issues/135)) ([1ef2c72](https://github.com/jhatler/janus/commit/1ef2c72473f1fdc406c63cb5344dd7cccb3f6381))
* **deps:** Update dependency boto3 to v1.34.117 ([#182](https://github.com/jhatler/janus/issues/182)) ([cfbd1c6](https://github.com/jhatler/janus/commit/cfbd1c67cbf5a67cb59822523db7cbfadad7386c))
* **deps:** Update dependency c8 to v9 ([#97](https://github.com/jhatler/janus/issues/97)) ([ad43553](https://github.com/jhatler/janus/commit/ad4355350ce3c6874493ac5a62e39e114617d9ff))
* **deps:** Update dependency cachetools to v5 ([#98](https://github.com/jhatler/janus/issues/98)) ([c30fce2](https://github.com/jhatler/janus/commit/c30fce2eca644f888746caaf0c57c5a8bad7b7e2))
* **deps:** Update dependency certifi to v2023.11.17 ([#76](https://github.com/jhatler/janus/issues/76)) ([8113719](https://github.com/jhatler/janus/commit/811371971c16430e683be2065d23150292ac6700))
* **deps:** Update dependency certifi to v2024 ([#99](https://github.com/jhatler/janus/issues/99)) ([3f0afc0](https://github.com/jhatler/janus/commit/3f0afc0579e488c8c248335e737503be42759368))
* **deps:** Update dependency cffi to v1.16.0 ([#77](https://github.com/jhatler/janus/issues/77)) ([aa9188b](https://github.com/jhatler/janus/commit/aa9188b0d2a18c249faea173110fbafad68f76ca))
* **deps:** Update dependency charset-normalizer to v3 ([#100](https://github.com/jhatler/janus/issues/100)) ([b2f8433](https://github.com/jhatler/janus/commit/b2f84336bb4d6487daff7a2c0727b24410ec3f28))
* **deps:** Update dependency click to v8.1.7 ([#78](https://github.com/jhatler/janus/issues/78)) ([312668b](https://github.com/jhatler/janus/commit/312668bd710be88911a0c93f0f803ab4dd7afca4))
* **deps:** Update dependency google-auth to v2.29.0 ([#79](https://github.com/jhatler/janus/issues/79)) ([067f97b](https://github.com/jhatler/janus/commit/067f97b5833800cb6d7e61f805d0a742142b2880))
* **deps:** Update dependency importlib-metadata to v7 ([#102](https://github.com/jhatler/janus/issues/102)) ([97ef5dd](https://github.com/jhatler/janus/commit/97ef5ddf121b75d5414b8592102cb70dc98ccb7c))
* **deps:** Update dependency jaraco-classes to v3.4.0 ([#80](https://github.com/jhatler/janus/issues/80)) ([8785216](https://github.com/jhatler/janus/commit/8785216decd223c52ada10828c6996eeca011828))
* **deps:** Update dependency keyring to v23.13.1 ([#81](https://github.com/jhatler/janus/issues/81)) ([0bba01e](https://github.com/jhatler/janus/commit/0bba01ec7d5357a9080641eae2a1914d82675222))
* **deps:** Update dependency keyring to v25 ([#103](https://github.com/jhatler/janus/issues/103)) ([6d52966](https://github.com/jhatler/janus/commit/6d529662a147ab7cf07d27ada151b4c531212625))
* **deps:** Update dependency keyrings-alt to v5 ([#104](https://github.com/jhatler/janus/issues/104)) ([eea3541](https://github.com/jhatler/janus/commit/eea35416c6ee50604a2c552d33ee46f6b8a4df40))
* **deps:** Update dependency lru-cache to v7.18.3 ([#82](https://github.com/jhatler/janus/issues/82)) ([0a551a5](https://github.com/jhatler/janus/commit/0a551a54301b83af055ddac1ace529e948057c35))
* **deps:** Update dependency mocha to v10.4.0 ([#83](https://github.com/jhatler/janus/issues/83)) ([8c0ec8a](https://github.com/jhatler/janus/commit/8c0ec8afd916ec79b16b9724c792c97078739bd4))
* **deps:** Update dependency more-itertools to v10 ([#106](https://github.com/jhatler/janus/issues/106)) ([ff6a254](https://github.com/jhatler/janus/commit/ff6a254903cc20af01489bf7efe3ba60f83ffb4d))
* **deps:** Update dependency more-itertools to v9.1.0 ([#84](https://github.com/jhatler/janus/issues/84)) ([ffb2483](https://github.com/jhatler/janus/commit/ffb2483598232f5f666b4d800ddd25d07477194a))
* **deps:** Update dependency nock to v13.5.4 ([#85](https://github.com/jhatler/janus/issues/85)) ([baa94e2](https://github.com/jhatler/janus/commit/baa94e2ae957abf1358c8bda25d7d2d246bd3a72))
* **deps:** Update dependency openai to v1.30.5 ([#139](https://github.com/jhatler/janus/issues/139)) ([d89f750](https://github.com/jhatler/janus/commit/d89f750411d4e1185fe2a4aa55450fd152447c2b))
* **deps:** Update dependency packaging to v23.2 ([#86](https://github.com/jhatler/janus/issues/86)) ([e322dee](https://github.com/jhatler/janus/commit/e322dee2fbb4ba0829804d9b24fc464b0ba6df9a))
* **deps:** Update dependency packaging to v24 ([#107](https://github.com/jhatler/janus/issues/107)) ([93d2e45](https://github.com/jhatler/janus/commit/93d2e45c798ced25e73f6cd0f9e204f00a5d88c8))
* **deps:** Update dependency protobuf to v5 ([#108](https://github.com/jhatler/janus/issues/108)) ([14fa414](https://github.com/jhatler/janus/commit/14fa4145eb99996eea1a606866683b7d6ed5951f))
* **deps:** Update dependency pyasn1 to v0.6.0 ([#87](https://github.com/jhatler/janus/issues/87)) ([435dcce](https://github.com/jhatler/janus/commit/435dcced19ae29f7a740c4c3ddfcb7960614ed60))
* **deps:** Update dependency pyasn1-modules to v0.4.0 ([#88](https://github.com/jhatler/janus/issues/88)) ([25a2803](https://github.com/jhatler/janus/commit/25a2803fa4bb60c7334914514818d2d080f58ee0))
* **deps:** Update dependency pycparser to v2.22 ([#89](https://github.com/jhatler/janus/issues/89)) ([5ebbc89](https://github.com/jhatler/janus/commit/5ebbc8919ac154b600d5741a771272aa0a87d471))
* **deps:** Update dependency pyjwt to v2.8.0 ([#90](https://github.com/jhatler/janus/issues/90)) ([39d205b](https://github.com/jhatler/janus/commit/39d205bc5cf98caae4691770168a3be203fb5d76))
* **deps:** Update dependency python-dateutil to v2.9.0.post0 ([#91](https://github.com/jhatler/janus/issues/91)) ([07d4fc0](https://github.com/jhatler/janus/commit/07d4fc0e23aa9340b1745bf29ddcf75b65411cc1))
* **deps:** Update dependency requests to v2.32.3 ([#140](https://github.com/jhatler/janus/issues/140)) ([245034f](https://github.com/jhatler/janus/commit/245034fed2e91dd3c350c7280d82377839cdbf41))
* **deps:** Update dependency sinon to v15.2.0 ([#92](https://github.com/jhatler/janus/issues/92)) ([d8dcccb](https://github.com/jhatler/janus/commit/d8dcccbe910b12eb89e94289bfbcb6d801a4869b))
* **deps:** Update dependency sinon to v18 ([#109](https://github.com/jhatler/janus/issues/109)) ([39a228d](https://github.com/jhatler/janus/commit/39a228d38e15064a9644181902a09ce218b3aa2f))
* **deps:** Update dependency smee-client to v1.2.5 ([#71](https://github.com/jhatler/janus/issues/71)) ([69d9f7f](https://github.com/jhatler/janus/commit/69d9f7fba59cc0f64a8f5ab02ece55b91706d285))
* **deps:** Update dependency smee-client to v2 ([#110](https://github.com/jhatler/janus/issues/110)) ([6b24437](https://github.com/jhatler/janus/commit/6b244374d77e37f76d5b0e24fd082eddf4354e7c))
* **deps:** Update dependency typescript to v4.9.5 ([#72](https://github.com/jhatler/janus/issues/72)) ([3998e26](https://github.com/jhatler/janus/commit/3998e26893bbbcc12b8c81208783c3d4d68f4915))
* **deps:** Update dependency typescript to v5 ([#111](https://github.com/jhatler/janus/issues/111)) ([922021d](https://github.com/jhatler/janus/commit/922021d645b0a9192236cb9e0e676945ea437536))
* **deps:** Update dependency urllib3 to v2 ([#112](https://github.com/jhatler/janus/issues/112)) ([aaaac72](https://github.com/jhatler/janus/commit/aaaac72bf766f951ae424ef8e1dc5c532c1b0a5a))
* **deps:** Update dependency zipp to v3.19.0 ([#93](https://github.com/jhatler/janus/issues/93)) ([c878034](https://github.com/jhatler/janus/commit/c8780340a548787d775f9eb7b2302964e9b00cd5))
* **deps:** Update dependency zipp to v3.19.1 ([#181](https://github.com/jhatler/janus/issues/181)) ([76276c3](https://github.com/jhatler/janus/commit/76276c370e93aa934e40a238e5f12d587f0f1d10))
* **deps:** Update github/codeql-action action to v3.25.7 ([#170](https://github.com/jhatler/janus/issues/170)) ([1f13d67](https://github.com/jhatler/janus/commit/1f13d6707d23e8b2095384a91fd8bab510028e6f))
* **deps:** Update ossf/scorecard-action action to v2.3.3 ([#169](https://github.com/jhatler/janus/issues/169)) ([8025c6e](https://github.com/jhatler/janus/commit/8025c6e54c3cf2647cdceba46fb73b3051619f70))
* Disable codeql and tfsec workflows ([#120](https://github.com/jhatler/janus/issues/120)) ([3baf648](https://github.com/jhatler/janus/commit/3baf64800a71edf1d2c83f752bcecbc43be67e96)), closes [#119](https://github.com/jhatler/janus/issues/119)
* Downgrade janus.js to typescript 5.1 ([#138](https://github.com/jhatler/janus/issues/138)) ([8ebcc16](https://github.com/jhatler/janus/commit/8ebcc165109b6931924ac637b3f457481d6cc084)), closes [#130](https://github.com/jhatler/janus/issues/130) [#137](https://github.com/jhatler/janus/issues/137)
* Enable chores in release notes ([#118](https://github.com/jhatler/janus/issues/118)) ([b18298a](https://github.com/jhatler/janus/commit/b18298adbf6835820f6bce6bad346eaef9aa61f3)), closes [#117](https://github.com/jhatler/janus/issues/117)
* Hoist common node dev dependencies ([#134](https://github.com/jhatler/janus/issues/134)) ([8603040](https://github.com/jhatler/janus/commit/8603040b8a738962034521a4c82b79993e3bbd56)), closes [#133](https://github.com/jhatler/janus/issues/133)
* Remove license badge from README ([#178](https://github.com/jhatler/janus/issues/178)) ([46e2c1d](https://github.com/jhatler/janus/commit/46e2c1d9aa7b726984c88245b5c3b2ee9eaa594f)), closes [#154](https://github.com/jhatler/janus/issues/154)
* Remove nx and lerna ([#132](https://github.com/jhatler/janus/issues/132)) ([73f858a](https://github.com/jhatler/janus/commit/73f858a4821ec72da811374c0934fa6921769c09)), closes [#131](https://github.com/jhatler/janus/issues/131)
* Super-linter only validates changed files ([#63](https://github.com/jhatler/janus/issues/63)) ([2773863](https://github.com/jhatler/janus/commit/27738631b38effb7f1e1dff3d5eaf6f5468ed0d7)), closes [#54](https://github.com/jhatler/janus/issues/54)

## [0.1.4](https://github.com/jhatler/janus/compare/janus-v0.1.3...janus-v0.1.4) (2024-05-28)


### Features

* Import release-trigger package ([#50](https://github.com/jhatler/janus/issues/50)) ([0b6b782](https://github.com/jhatler/janus/commit/0b6b782313ee2638661873cc62433d351c9e50c1))


### Bug Fixes

* Correct CHANGELOG headers ([#51](https://github.com/jhatler/janus/issues/51)) ([58c7891](https://github.com/jhatler/janus/commit/58c7891e84343fa91c16c3309174c3a8e1a8229f)), closes [#47](https://github.com/jhatler/janus/issues/47)

## [0.1.3](https://github.com/jhatler/janus/compare/janus-v0.1.2...janus-v0.1.3) (2024-05-27)


### Bug Fixes

* Container attestation fixes ([#38](https://github.com/jhatler/janus/issues/38)) ([92ca0e9](https://github.com/jhatler/janus/commit/92ca0e9d275d9a2712df79229e1a8e50a0c95274)), closes [#37](https://github.com/jhatler/janus/issues/37)
* Overhaul devcontainer and container actions ([#41](https://github.com/jhatler/janus/issues/41)) ([579dc0f](https://github.com/jhatler/janus/commit/579dc0fb18f0e324900274e2112489397cefddd0)), closes [#37](https://github.com/jhatler/janus/issues/37)

## [0.1.2](https://github.com/jhatler/janus/compare/janus-v0.1.1...janus-v0.1.2) (2024-05-27)


### Bug Fixes

* Perform attest before cleanup ([#35](https://github.com/jhatler/janus/issues/35)) ([49146e6](https://github.com/jhatler/janus/commit/49146e67b0dd18b70f97a6e950af01f6a2e8cc28)), closes [#34](https://github.com/jhatler/janus/issues/34)

## [0.1.1](https://github.com/jhatler/janus/compare/janus-v0.1.0...janus-v0.1.1) (2024-05-27)


### Bug Fixes

* Remove vscode extension valentjn.vscode-ltex ([0a36654](https://github.com/jhatler/janus/commit/0a366548840c35f47faa6c2679a464179c6ecb4d)), closes [#31](https://github.com/jhatler/janus/issues/31)
* Use image digest instead of id to attest ([ccb9624](https://github.com/jhatler/janus/commit/ccb96246fd59767d34ee10470d2fb81c43680da5)), closes [#29](https://github.com/jhatler/janus/issues/29)

## 0.1.0 (2024-05-27)


### Features

* Add AUTHORS and CONTRIBUTORS.md files ([2eb7bc2](https://github.com/jhatler/janus/commit/2eb7bc2ff607bd42e0bc114521eb85ebdb641c18)), closes [#2](https://github.com/jhatler/janus/issues/2)
* Add CODEOWNERS file ([9788a20](https://github.com/jhatler/janus/commit/9788a20f35ed5eb93bba4867477aa886e94a4632)), closes [#3](https://github.com/jhatler/janus/issues/3)
* Add contributing guide ([78cfaa2](https://github.com/jhatler/janus/commit/78cfaa2a81900d905b2675a827a752c521fc057e)), closes [#6](https://github.com/jhatler/janus/issues/6)
* Add copyright policy ([5e37a85](https://github.com/jhatler/janus/commit/5e37a856b90c5d1a13d641310344a5493ba4fa8c)), closes [#5](https://github.com/jhatler/janus/issues/5)
* Add devcontainer and other GitHub configs ([#9](https://github.com/jhatler/janus/issues/9)) ([e900bd9](https://github.com/jhatler/janus/commit/e900bd98b4221022b0242448ed9f5ff36546d980)), closes [#8](https://github.com/jhatler/janus/issues/8)
* Add licenses ([d06b0d5](https://github.com/jhatler/janus/commit/d06b0d53bc508455bd4afce0d2e8c1d4f8ef5bbc)), closes [#1](https://github.com/jhatler/janus/issues/1)
* Add security policy ([0044212](https://github.com/jhatler/janus/commit/004421225a9d95370b054b4e00a481d2a41e4970)), closes [#7](https://github.com/jhatler/janus/issues/7)
* Join the Contributor Covenant ([9f2cc58](https://github.com/jhatler/janus/commit/9f2cc581aa51f38e485340c34de4680c399615f4)), closes [#4](https://github.com/jhatler/janus/issues/4)


### Bug Fixes

* Correct dependabot paths ([3d0fe57](https://github.com/jhatler/janus/commit/3d0fe5789bdd542ec9f183293aefde138a1f1b6c)), closes [#12](https://github.com/jhatler/janus/issues/12)
* Correct pyJanus name in release-please ([b88b099](https://github.com/jhatler/janus/commit/b88b099ac445ba31d230478fdcee6be7e1b7c695)), closes [#20](https://github.com/jhatler/janus/issues/20)
* Correct release type for release-please ([c3cb8fc](https://github.com/jhatler/janus/commit/c3cb8fc128bb581f9c0065e74cac1e242bbdd4e0)), closes [#11](https://github.com/jhatler/janus/issues/11)
* Force generic updater in release-please ([564771c](https://github.com/jhatler/janus/commit/564771c6fbb1ed9351a8de4bdaf1fec598fdd9c7)), closes [#27](https://github.com/jhatler/janus/issues/27)
* Standardize on node user in containers ([b57058d](https://github.com/jhatler/janus/commit/b57058da4fecc47aa6659b56973ac30324c9aeb1)), closes [#14](https://github.com/jhatler/janus/issues/14)
