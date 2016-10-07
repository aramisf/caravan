# caravan

Application for our financial conscience caravan!

## Deploying

If you want to deploy a quick test environment, you can use this heroku deploy
button here:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

It will ask all the environment variables needed! Be sure to keep app.json up to
date, than this will always work.

## Development

This project is our first Phoenix project, and we are trying not to complicate
it with big libs, and we are following all the conventions we found for Phoenix.

To start your Phoenix app:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Populate the database with `mix run priv/repo/seeds.exs` - PS.: check this
file if you want to know a user and password to login
* Install Node.js dependencies with `npm install`
* Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributing

It's pretty simple, but information is never too much, right?

### THE RULES

* `master` is **deployable**, if it's in this branch, it can be in production
* For real, **that's the only rule**, beside master, do whatever you want
* But if you work better with a workflow to follow, we sugest this one:
  * Create a new branch, based from master `git checkout -b my_feature`
  * Do your changes
  * Create tests (if you want to TDD, we don't care, we just need tests)
  * Be sure `mix tests` is running
  * Do atomic commits, **don't commit** if the tests are not passing
  * Open a pull-request to it `hub pull-request -m "My feature"`
  * Wait for revision, and fix something if needed
  * When merged, go to master `git checkout master`
  * And delete your branch `git branch -D my_feature`

**PS.:** Dear reviewer, please **always** remember to ask for a `git rebase
master` before merging! To make our `git log` less like:

```
*   482b533 Merge pull request #795 from bad/master
|\
* \   f2d88dd Merge pull request #793 from bad/master
|\ \
* \ \   55685b1 Merge pull request #792 from bad/master
|\ \ \
* \ \ \   c2c40b0 Merge pull request #791 from bad/master
|\ \ \ \
* \ \ \ \   ac1abbc Merge pull request #790 from bad/master
...
```

And more like this:

```
*   96d7522 Merge pull request #27 from good/reports-order
|\
| * 3e89c38 Fixing joins typo
|/
*   22a834e Merge pull request #26 from good/archive-projects
|\
| * 043153b Adds users to seeds
|/
* 7fab6a6 Merge pull request #25 from good/archive-projects
...
```

## Learn more

* Official website: http://www.phoenixframework.org/
* Guides: http://phoenixframework.org/docs/overview
* Docs: https://hexdocs.pm/phoenix
* Mailing list: http://groups.google.com/group/phoenix-talk
* Source: https://github.com/phoenixframework/phoenix
* Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## More Details

* Authentication was developed following [this guide](https://medium.com/@andreichernykh/phoenix-simple-authentication-authorization-in-step-by-step-tutorial-form-dc93ea350153)
* Authorization was made using [this gem](https://github.com/schrockwell/bodyguard)
