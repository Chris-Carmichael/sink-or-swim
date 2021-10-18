# Terraform Modules

All modules go here.  If you're leveraging existing modules, copy them here and reference the upstream in documentation.

## Design Decisions

Most of these decisions are style-based decisions, some of which are based on my past experience.  None of these are necessarily the one, true way to design or manage a set of modules that make up a landscape or project.

### Why Modules?

This is a small demonstration project.  Why have modules split out vs. using resources?

Even though this is a small project, I decided to create or leverage modules for reusability and use separate state buckets to reduce blast radius and make doing surgery / experimentation easier.

## Why a Monorepo?

Technically, this isn't even a monorepo because it's all nested in an application source repo, but let's pretend for a second it's a single TF repo since that's how I would probably do it for a project this small.

Keeping a project in a single repo would allow us to version / tag this to track an entire landscape as a release, which is a pattern I've done in the past.

We could also separate out modules into separate repos with tagging to add more rigor.  This adds more control around drift as upstream resoures and modules get updated.  The trade-off is extra maintenence when attempting to stay current.

## Why Clone Pre-built Modules?

Why clone the terraform-aws-vpc module?  Couldn't we just refer to the external module with the version tagged for the extra control outlined above?

Yes, that is another valid pattern, but I chose to clone the repo (not fork) so that the code changes can be seen in our repo as we upgrade the solution.  It also removes an external dependency in case the original author of the upstream repo goes dark.  Unlikely with this Github org, but sometimes happens if you're leveraging smaller Github orgs.

