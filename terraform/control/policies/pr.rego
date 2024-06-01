package spacelift

import future.keywords.contains
import future.keywords.if
import future.keywords.in

header := sprintf("### Resource changes ([link](https://%s.app.spacelift.io/stack/%s/run/%s))\n\n![add](https://img.shields.io/badge/add-%d-brightgreen) ![change](https://img.shields.io/badge/change-%d-yellow) ![destroy](https://img.shields.io/badge/destroy-%d-red)\n\n| Action | Resource | Changes |\n| --- | --- | --- |", [input.account.name, input.run_updated.stack.id, input.run_updated.run.id, count(added), count(changed), count(deleted)])

addedresources := concat("\n", added)
changedresources := concat("\n", changed)
deletedresources := concat("\n", deleted)

added contains row if {
  some x in input.run_updated.run.changes

  row := sprintf("| Added | `%s` | <details><summary>Value</summary>`%s`</details> |", [x.entity.address, x.entity.data.values])
  x.action == "added"
  x.entity.entity_type == "resource"
}

changed contains row if {
  some x in input.run_updated.run.changes

  row := sprintf("| Changed | `%s` | <details><summary>New value</summary>`%s`</details> |", [x.entity.address, x.entity.data.values])
  x.entity.entity_type == "resource"

  any([x.action == "changed", x.action == "destroy-Before-create-replaced", x.action == "create-Before-destroy-replaced"])
}

deleted contains row if {
  some x in input.run_updated.run.changes
  row := sprintf("| Deleted | `%s` | :x: |", [x.entity.address])
  x.entity.entity_type == "resource"
  x.action == "deleted"
}

pull_request contains {"commit": input.run_updated.run.commit.hash, "body": replace(replace(concat("\n", [header, addedresources, changedresources, deletedresources]), "\n\n\n", "\n"), "\n\n", "\n")} if {
  input.run_updated.run.state == "FINISHED"
  input.run_updated.run.type == "PROPOSED"
}
