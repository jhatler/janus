# Terraform Control Changelog
<!--- @generated --->


## [0.1.1](https://github.com/jhatler/janus/compare/tf-control-v0.1.0...tf-control-v0.1.1) (2024-07-11)


### Features

* Add admin Spacelift stack ([#294](https://github.com/jhatler/janus/issues/294)) ([5d54b46](https://github.com/jhatler/janus/commit/5d54b463c3cfd5733afd79fe2f56dfdac554f1c2)), closes [#292](https://github.com/jhatler/janus/issues/292)
* Add auth and crypto stacks ([#317](https://github.com/jhatler/janus/issues/317)) ([0ce4dda](https://github.com/jhatler/janus/commit/0ce4ddac0f938ccf996468c3c564c6646fbbe4f4))
* Add CHANGELOG/README/Tests to github_oidc ([#308](https://github.com/jhatler/janus/issues/308)) ([0d373c3](https://github.com/jhatler/janus/commit/0d373c3d32339b491e8b4cbaca158bcfcd00f3ea)), closes [#300](https://github.com/jhatler/janus/issues/300)
* Add GitHub OIDC Terraform Module ([#289](https://github.com/jhatler/janus/issues/289)) ([bc9a3b7](https://github.com/jhatler/janus/commit/bc9a3b70f35af31b527b68d36f7cd83967ed94bd)), closes [#288](https://github.com/jhatler/janus/issues/288)
* Add network stack ([#291](https://github.com/jhatler/janus/issues/291)) ([47eef0d](https://github.com/jhatler/janus/commit/47eef0dad11ebb36fb2740dda4dc1dcc1d0b359d)), closes [#290](https://github.com/jhatler/janus/issues/290)
* Add runner-template stack ([#368](https://github.com/jhatler/janus/issues/368)) ([3192725](https://github.com/jhatler/janus/commit/319272549dd20172e3d85444ff34823b6b63a0e9)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Add runners stack to Spacelift ([#333](https://github.com/jhatler/janus/issues/333)) ([3ffcc9e](https://github.com/jhatler/janus/commit/3ffcc9e2869812d36142d7adc4df96a357eeeedd)), closes [#278](https://github.com/jhatler/janus/issues/278)
* Add ssm Spacelift stack ([#351](https://github.com/jhatler/janus/issues/351)) ([7fa380d](https://github.com/jhatler/janus/commit/7fa380dc2557cf3d26c58ab8e431f40666ccde21)), closes [#349](https://github.com/jhatler/janus/issues/349)
* Add stack for receiving webhooks ([#337](https://github.com/jhatler/janus/issues/337)) ([87ae708](https://github.com/jhatler/janus/commit/87ae708a68901faa6bdd4f5f3f4bea33b70f9818)), closes [#336](https://github.com/jhatler/janus/issues/336)
* Add stacks for ECR access ([#409](https://github.com/jhatler/janus/issues/409)) ([e7ae358](https://github.com/jhatler/janus/commit/e7ae35858383908f0938fdc6d05328937c0aa974)), closes [#406](https://github.com/jhatler/janus/issues/406)
* Always trigger stack deps ([#348](https://github.com/jhatler/janus/issues/348)) ([2102e53](https://github.com/jhatler/janus/commit/2102e53d24c47ae5389d3e0227cce4e441d56894)), closes [#347](https://github.com/jhatler/janus/issues/347)
* Integrate runners stack with ssm stack ([#353](https://github.com/jhatler/janus/issues/353)) ([4b723a9](https://github.com/jhatler/janus/commit/4b723a9ff501c02a0afc6ccd9a31d45b3162372e)), closes [#352](https://github.com/jhatler/janus/issues/352)
* Spacelift AWS integrations are self-managed ([#280](https://github.com/jhatler/janus/issues/280)) ([a7f4953](https://github.com/jhatler/janus/commit/a7f49537aebf06916de5952326e92dd172d48ad2)), closes [#279](https://github.com/jhatler/janus/issues/279)
* Spacelift stack dependencies ([#299](https://github.com/jhatler/janus/issues/299)) ([571cd67](https://github.com/jhatler/janus/commit/571cd67e83f2619d50037f3576d1c78d29f22aa2)), closes [#298](https://github.com/jhatler/janus/issues/298)


### Bug Fixes

* Add crypto stack as a network dependency ([#323](https://github.com/jhatler/janus/issues/323)) ([2f27653](https://github.com/jhatler/janus/commit/2f2765384ed569bc325acd3f2583c0baa9affe97)), closes [#322](https://github.com/jhatler/janus/issues/322)
* Add TF_VAR_ prefix to spacelift dep refs ([#313](https://github.com/jhatler/janus/issues/313)) ([6ebd3cb](https://github.com/jhatler/janus/commit/6ebd3cb7239cc8580259226e6bdd96236e112f2e)), closes [#312](https://github.com/jhatler/janus/issues/312)
* Apply cloud integrations after stack create ([#287](https://github.com/jhatler/janus/issues/287)) ([3f21ff4](https://github.com/jhatler/janus/commit/3f21ff425392a61fa1799e3012e72df28829f8e1)), closes [#286](https://github.com/jhatler/janus/issues/286)
* Network IAM configuration ([#327](https://github.com/jhatler/janus/issues/327)) ([04180c5](https://github.com/jhatler/janus/commit/04180c53c4576c7b197bb7219b7c38495231e5f1)), closes [#326](https://github.com/jhatler/janus/issues/326)
* Output stack id instead of ARN ([#332](https://github.com/jhatler/janus/issues/332)) ([f7d8edc](https://github.com/jhatler/janus/commit/f7d8edc72494b350b22557fd83db4236c8320811)), closes [#331](https://github.com/jhatler/janus/issues/331)
* Pass KMS key to runners stack ([#335](https://github.com/jhatler/janus/issues/335)) ([d46c0ea](https://github.com/jhatler/janus/commit/d46c0ea0db64288dc97982caac238bb1322f593d)), closes [#334](https://github.com/jhatler/janus/issues/334)
* Pass stack role to auth stack as input ([#330](https://github.com/jhatler/janus/issues/330)) ([eefbfef](https://github.com/jhatler/janus/commit/eefbfef748d5086aa822cf3e62c3cbb748fb3abb)), closes [#329](https://github.com/jhatler/janus/issues/329)
* Refactor sts external id creation ([#361](https://github.com/jhatler/janus/issues/361)) ([152ed62](https://github.com/jhatler/janus/commit/152ed627033bbbd5007f1511e8583e2f7944e886)), closes [#359](https://github.com/jhatler/janus/issues/359)
* Remove alias from AWS provider ([#283](https://github.com/jhatler/janus/issues/283)) ([6929f46](https://github.com/jhatler/janus/commit/6929f46954e104b352a534e2ae533599bf659c4a)), closes [#282](https://github.com/jhatler/janus/issues/282)
* Spacelift determines control repo via context ([#285](https://github.com/jhatler/janus/issues/285)) ([b9ee3d5](https://github.com/jhatler/janus/commit/b9ee3d5dc209dfa943c426f5f94bb367c755caca)), closes [#284](https://github.com/jhatler/janus/issues/284)
* Update runners/webhooks/ssm crypto access ([#375](https://github.com/jhatler/janus/issues/375)) ([d3f8c1e](https://github.com/jhatler/janus/commit/d3f8c1e8585f59677c74e97f7d45eb4dadb98a44)), closes [#362](https://github.com/jhatler/janus/issues/362)
* Use module slug for aws integration ([#360](https://github.com/jhatler/janus/issues/360)) ([10c40ac](https://github.com/jhatler/janus/commit/10c40aca5f0ae52ea24b90efa51636f061b55f50)), closes [#359](https://github.com/jhatler/janus/issues/359)


### Miscellaneous Chores

* **deps:** Bump hashicorp/aws in /terraform/control ([#302](https://github.com/jhatler/janus/issues/302)) ([5c69c2a](https://github.com/jhatler/janus/commit/5c69c2ae98f048ec02bda25a02d984f590cf537c))
* **deps:** Update terraform aws to v5.56.1 ([#281](https://github.com/jhatler/janus/issues/281)) ([bd2e90b](https://github.com/jhatler/janus/commit/bd2e90b01f4f3c777291306df80bcf94f6d1e4bd))
* **deps:** Update terraform aws to v5.57.0 ([#386](https://github.com/jhatler/janus/issues/386)) ([9053463](https://github.com/jhatler/janus/commit/9053463e61e5f00c0515e81e9a64ee0cd06cd700))
* **deps:** Update terraform spacelift to v1.14.0 ([#218](https://github.com/jhatler/janus/issues/218)) ([e2a9c56](https://github.com/jhatler/janus/commit/e2a9c5685f7a5389d7e74d86acd03deba53face4))
* Move ubuntu-cloudimg containers to ECR ([#410](https://github.com/jhatler/janus/issues/410)) ([2f69d2e](https://github.com/jhatler/janus/commit/2f69d2ec323aef6f01bb07d947e14670a5f2f69f)), closes [#406](https://github.com/jhatler/janus/issues/406)

## 0.1.0 (2024-05-31)


### Features

* Add initial terraform/spacelift support ([#49](https://github.com/jhatler/janus/issues/49)) ([11370b7](https://github.com/jhatler/janus/commit/11370b74b8147df6496e3b807b1a78c7b3226164)), closes [#46](https://github.com/jhatler/janus/issues/46)
* Give terraform resources their own releases ([#192](https://github.com/jhatler/janus/issues/192)) ([714b460](https://github.com/jhatler/janus/commit/714b460ecab22fd131651d12462b29b3ef115614)), closes [#183](https://github.com/jhatler/janus/issues/183)


### Bug Fixes

* Correct terraform release setup ([#193](https://github.com/jhatler/janus/issues/193)) ([641ceb5](https://github.com/jhatler/janus/commit/641ceb5475de19ab20e84fa7342c79841fac0abf)), closes [#183](https://github.com/jhatler/janus/issues/183)
* Hello_world spacelift stack is administrative ([#199](https://github.com/jhatler/janus/issues/199)) ([9867022](https://github.com/jhatler/janus/commit/986702276ad7679d851301363b031e02c625377e)), closes [#198](https://github.com/jhatler/janus/issues/198)


### Miscellaneous Chores

* **deps:** Update dependency @types/sinon to v10.0.20 ([#69](https://github.com/jhatler/janus/issues/69)) ([4754d30](https://github.com/jhatler/janus/commit/4754d304a80c7f2de2a5015fbcb74f6edfb69843))
* Initial empty commit ([0fd3265](https://github.com/jhatler/janus/commit/0fd32650d56b8bd4b5c12a74ab41f6da4b6ad26b))

## Control Stack Changelog
<!--- @generated --->
