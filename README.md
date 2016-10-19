# cfn-deploy

Provides a convention and workflow for creating AWS Cloudformation with [cfndsl](https://github.com/stevenjack/cfndsl) and [stackup](https://github.com/realestate-com-au/stackup).

[cfndsl](https://github.com/stevenjack/cfndsl) is a great tool for writing cloudformation in Ruby. It provides better compile time checking and allows you to dynamically create tedious or long winded resources (eg, mutiple subnets).

[stackup](https://github.com/realestate-com-au/stackup) is a nice wrapper around cloudformation stack creates and updates the provides a better command line experience, overriding parameters on the command and using yaml for parameter files.

cfn-deploy combines these two great tools and provides a build tool binary (using [shake](http://shakebuild.com/)) that will automatically re-compile or deploy your templates based off file layout and naming conventions. This standardises all your cloudformation repos, and reduces the amount of typing (ie typos) when you are deploying. This is all packaged into a single docker image!

## Getting started

### Usage

I recommend using [Docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/) so that all people using your repos will be on the same environment.

Once you have your environment installed, all you need to do is add in the following `docker-compose.yml` file in the root of your project:

```yaml
---
cfn:
  image: pvdvreede/cfn-deploy:latest
  workingdir: /app
  volumes:
    - ".:/app"
```

Provided your files are laid out correctly (see below) you should be able to run the following commands:

```bash
docker-compose run cfn clean # cleans the cfn/ folder
docker-compose run cfn compile # compiles all templates in repo
docker-compose run cfn cfn/<template name>.json # compiles a specific template
```

### File layout and naming conventions

In order for cfn-deploy to work, you need to make sure you layout your files in the correct folders with the correct naming.

#### Templates

cfn-deploy can support multiple templates in the one repo. Each template is in it's own folder under the `templates` directory. As cfndsl allows you to require other Ruby files or read in any other file, cfn-deploy will re compile your template if any files in the template folder change. There must be at least a `.rb` file in the template folder with the same name as the template folder; this is the entrypoint for cfndsl, eg `templates/my_first_template/my_first_template.rb`.

#### Parameters

TBD
