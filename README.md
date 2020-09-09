# chef-supermarket.ingenerator.com

This project uses [minimart](https://github.com/electric-it/minimart) to build a [custom chef supermarket
repository](https://chef-supermarket.ingenerator.com) for our internal wrapper cookbooks and similar that aren't ready / 
appropriate to add to the public chef supermarket.

It may also include references for third-party cookbooks that haven't been published on supermarket.

Note that:

* the cookbook endpoint and the cookbooks are still available to the public, so cookbooks still need to
  follow semver and avoid containing any proprietary config / code that should be bundled in at a (private)
  project level.
* these cookbooks will be less discoverable than ones listed on supermarket : if the cookbook is stable /
  useful for a wider audience then it should probably be published there instead.
* Github pages cannot serve `/universe` as `application/json`. We use the workaround of publishing the universe file as
  `/universe/index.json` - this then causes `/universe` to redirect to `/universe/` which serves the JSON with the 
  correct content type. **This is not, strictly, compliant with the chef API definition but berkshelf appears to follow
  it happily**
  
## Building the repository

* See the github actions workflow
  
## Adding new cookbooks

Explicit versions / branches / tags etc can be added to the `inventory_base.yml` file - see the 
[minimart docs](https://github.com/electric-it/minimart#mirroring-cookbooks).

For github-backed cookbooks with well-behaved version tagging, you can also configure the inventory to publish
every tagged version of the project. Add the following to `inventory_base.yml`:

```yaml
cookbooks:
  our-project:
    github-tags: ingenerator/our-project-repo
```

Before running minimart, our builder will use the github API to list all tags for the `ingenerator/our-project-repo` 
repository and add every tag it finds to the minimart inventory for the `our-project` cookbook.

License & Authors
-----------------
- Author:: Andrew Coulton (andrew@ingenerator.com)

```text
Copyright 2017, inGenerator Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
