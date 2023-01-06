Acceptance-Unit Test Cycle
===


In this assignment you will use a combination of Acceptance and Units tests with the Cucumber and RSpec tools to add a "find movies with same director" feature to RottenPotatoes.

**To start: fork this repo and then clone your fork.**

Learning Goals
--------------
After you complete this assignment, you should be able to:
* Create and run simple Cucumber scenarios to test a new feature
* Use RSpec to create unit tests that drive the creation of app code that lets the Cucumber scenario pass
* Understand where to modify a Rails app to implement the various parts of a new feature, since a new feature often touches the database schema, model(s), view(s), and controller(s)


Introduction and Setup
----
Clone **your fork** of this repo to your development environment (**do not clone** this reference repo or you'll be unable to push your changes);

e.g. `git clone https://github.edu/[account/organization]/hw-acceptance-unit-test-cycle`

Once you have the clone of the repo:

1. Change into the rottenpotatoes directory: 

```sh
cd hw-acceptance-unit-test-cycle/rottenpotatoes
```

2. Run 

```sh
bundle config set --local without 'production' && bundle install
```

to make sure all gems are properly installed.  

**NOTE:** If Bundler complains that the wrong Ruby version is installed,

* **rvm**: verify that `rvm` is installed (for example, `rvm --version`) and say `rvm list` to see which Ruby versions are available and `rvm use <version>` to make a particular version active.  If no versions satisfying the Gemfile dependency are installed, you can say `rvm install <version>` to install a new version, then `rvm use <version>` to use it.

* **rbenv**: verify that `rbenv` is installed (for example, `rbenv --version`) and say `rbenv versions` to see which Ruby versions are available and `rbenv local <version>` to make a particular version active.  If no versions satisfying the Gemfile dependency are installed, you can say `rbenv install <version>` to install a new version, then `rbenv local <version>` to use it.

Then you can try `bundle install` again.

3. Create the initial database schema:


```sh
rake db:migrate
```

If rake complains that `ExecJS::RuntimeUnavailable: Could not find a JavaScript runtime`, then you need to install node.js and reattempt the migrations: 

```sh
sudo apt install nodejs && rake db:migrate
```

If rake complains that `Sprockets::Railtie::ManifestNeededError: Expected to find a manifest file in 'app/assets/config/manifest.js'`, then you need to create that file and put some stuff in it by running the following in the terminal:

```shell
mkdir -p app/assets/config
{
  echo "//= link_directory ../javascripts .js"
  echo "//= link_directory ../stylesheets .css"
} > app/assests/config/manifest.js
```

Then rereun `rake db:migrate`.  If rake complains that `Directly inheriting from ActiveRecord::Migration is not supported`, then you need to add the rails version to your migration files, e.g. `class CreateMovies < ActiveRecord::Migration[6.1]`.

This should be the last time you have to attempt to rerun `rake db:migrate`.

Now do:

```shell
rake db:test:prepare
```

4. If you like, add some more seed data in `db/seeds.rb`.  Then, run `rake db:seed` to add it to the database.

5. Double check that RSpec is correctly set up by running `rake spec`.  (Note--*not* `rake rspec` as you might think. Sorry.)  There are already some RSpec tests written and you should expect them to fail right now.

6. Double check that Cucumber is correctly set up by running `rake cucumber`.  We've provided a couple of scenarios that will fail, which you can use as a starting point, in `features/movies_by_director.feature`.

If rake complains that `Don't know how to build task 'cucumber'`, then you need to run 

```sh
rails generate cucumber:install
```  

Say `Y` to all requests to overwrite.  Then re-add to `features/support/env.rb` at the top:

```ruby
require 'simplecov'
SimpleCov.start 'rails'
```

Then run 
```sh
rake cucumber
```

<details>
  <summary> 
  Read the Cucumber failure error messages.  The first test failure should be: <br/>
  Undefined step: the director of "Alien" should be "Ridley Scott" <br/>
  What will you have to do to address that specific error?  
  </summary>
  <p>
  <blockquote> 
  You'll have to write a definition for this step in movie_steps.rb
  </blockquote>
  </p>
</details>


# Part 1: add a Director field to Movies

Create and apply a migration that adds the Director field to the movies table. The director field should be a string containing the name of the movie’s director. 

* Hint: you may find the `rails generate migration ...` tool useful.
* Hint: you may find the [`add_column` method of `ActiveRecord::Migration`](http://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_column) useful.
* Remember that once the migration is applied, you also have to do `rake db:test:prepare`
to load the new post-migration schema into the test database.

<details>
  <summary>
  Clearly, now that a new field has been added, we will have to modify the Views so that the user can see and enter values for that field. Do we also have to modify the model file in order for the new field to be "noticed"?
  </summary>
  <p>
  <blockquote> 
  Nope.  ActiveRecord infers the columns and their data types by inspecting the database.  However, if we wanted to have a validation on that column, we'd have to specifically mention it in a <code>validates</code> call.
  </blockquote>
  </p>
</details>

<details>
  <summary> 
  Look at the step definitions for the failing steps of the Cucumber scenarios.  (Where would you find those definitions?)  Based on the step definitions, which step(s) of the scenario file would you now expect to *pass* if you re-run Cucumber, and why?
  </summary>
  <p>
  <blockquote> 
  Once this field is added, running <code>rake cucumber</code> should allow the <code>Background:</code> steps to pass, since they just use ActiveRecord directly to create movies with a Director field.  But the other scenarios all manipulate the user interface (the views), which you have not yet modified, so they will still fail.
  </blockquote>
  </p>
</details>

Verify that the Cucumber steps you expect to pass actually do pass.

<details>
  <summary>
  Besides modifying the Views, will we have to modify anything in the controller?  If so, what? 
  </summary>
  <p>
  <blockquote> 
  Yes: we have to add <code>:director</code> to the list of movie attributes in the <code>def movie_params</code> method in <code>movies_controller.rb</code>.  Otherwise, even if that value is available as <code>params["movie"]["director"]</code>, it will be "scrubbed" by the <code>require</code> and <code>permit</code> calls on <code>params</code> before the controller actions are able to see it.
  </blockquote>
  </p>
</details>

<details>
  <summary>
  Which controller actions, specifically, would fail to work correctly if we didn't make the above change?
  </summary>
  <p>
  <blockquote> 
  <code>create</code> and <code>update</code> would fail, since they are the ones that expect a form submission in <code>params</code> in which <code>params["movies"]</code> should appear.  The other actions do not expect or manipulate this form (and do not call the helper function <code>movie_params</code>) so they would not be affected.
  </blockquote>
  </p>
</details>

Based on the above self-checks, you should be able to modify the controller and views as needed to be "aware" of the new Director field.

So do that now: **modify the controller and views as needed to be "aware" of the new Director field.**



# Part 2: use Acceptance and Unit tests to get new scenarios passing

We've provided three Cucumber scenarios in the file `features/movies_by_director.feature` to drive creation of two happy paths and one sad path of Search for Movies by Director. The first lets you add director info to an existing movie, and doesn't require creating any new views or controller actions, but does require modifying existing views, and will require creating a new step definition. 

The second lets you click a new link on a movie details page "Find Movies with Same Director", and shows all other movies that share the same director as the displayed movie.  For this you'll have to modify the existing Show Movie view, and you'll have to add a route, view and controller method for Find With Same Director.  

The third handles the sad path, when the current movie has no director info but we try to do "Find Movies with Same Director" anyway.

Going one Cucumber step at a time, use RSpec to create the appropriate controller and model specs to drive the creation of the new controller and model methods.  At the least, you will need to write tests to drive the creation of: 

+ a RESTful route for Find Similar Movies (HINT: use the 'match' syntax for routes as suggested in "Non-Resource-Based Routes" in the [Rails Routing documentation](http://guides.rubyonrails.org/routing.html)). You can also use the key `:as` to specify a name to generate helpers (i.e. search_directors_path)  Note: you probably won’t test this directly in a spec, but a line in Cucumber or rspec will fail if the route is not correct.

+ a controller method to receive the click on "Find with Same Director", and grab the `id` (for example) of the movie that is the subject of the match (i.e. the one we're trying to find movies similar to) 

+ a model method in the `Movie` model to find movies whose director matches that of the current movie.

<details>
  <summary> 
  Would this model method be a class method or instance method?
  </summary>
  <p>
  <blockquote> 
  Technically it could be either.  You could call it on a movie, the idea being that it returns other movies with the same director as its receiver, e.g. <code>movie.others_by_same_director()</code>.  Or you could define it as a class method, e.g. <code>Movie.with_director(director)</code>. In fact, it's great practice to write it both ways.
  </blockquote>
  </p>
</details>

Verify that the Cucumber steps you expect to pass actually do pass.

Note: You should write at least 2 specs for your controller:
1) When the specified movie has a director, it should...
2) When the specified movie has no director, it should ...

and at least 2 specs for your model:
1) it should return the correct matches for movies by the same director and
2) it should not return matches of movies by different directors.

It's up to you to decide whether you want to handle the sad path of "no director" in the controller method or in the model method, but you must provide a test for whichever one you do. **Remember to include the line** `require 'rails_helper'` at the top of every `*_spec.rb` file.

# Part 3: Code Coverage

We want you to report your code coverage as well.

Notice that the Gemfile includes the SimpleCov gem, and that the first two lines of `rails_helper.rb` file (which you should be `require`ing at the top of every `*_spec.rb` file) as well as the first and only two lines of `features/support/simplecov.rb` (which Cucumber loads automatically when run) start the SimpleCov test coverage measurement.

Each time you run `rspec` or `cucumber`, SimpleCov  generates a report in a directory named `coverage/`. Since both RSpec and Cucumber are so widely used, SimpleCov can intelligently merge the results, so running the tests for Rspec does not overwrite the coverage results from Cucumber and vice versa.

To see the results, open `coverage/index.html` with a browser or HTML preview extension to view your coverage report.  If you cannot view the page remotely, download the coverage folder and view it locally.

Improve your test coverage to at least 90% by adding unit tests for untested or undertested code and by removing code which you do not need.

# Part 4: Code Quality

run `rubocop` and `rubycritic` and address most, if not all, of the issues they find.

# Submission:

Add, commit, and push your changes to your git repository.  Your instructor should have read access to your repo (or your repo should be public).  Submit the address of your repo to the assignment on Canvas.

<!--
Here are the instructions for submitting your assignment for grading. Submit a zip file containing the following files and directories of your app:

* `app/`
* `config/`
* `db/migrate`
* `db/schema.rb`
* `db/seeds.rb`
* `features/`
* `spec/`
* `Gemfile`
* `Gemfile.lock`

If you modified any other files, please include them too. If you are on a *nix based system, navigate to the root directory for this assignment and run

```sh
$ cd ..
$ zip -r acceptance-tests.zip rottenpotatoes/app/ rottenpotatoes/config/ rottenpotatoes/db/migrate rottenpotatoes/features/ rottenpotatoes/spec/ rottenpotatoes/Gemfile rottenpotatoes/Gemfile.lock
```

This will create the file `acceptance-tests.zip`, which you will submit.

IMPORTANT NOTE: Your submission must be zipped inside a rottenpotatoes/ folder so that it looks like this:

```
$ tree
.
└── rottenpotatoes
    ├── Gemfile
    ├── Gemfile.lock
    ├── app
    ...
```
-->
