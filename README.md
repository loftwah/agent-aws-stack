# Semaphore agent AWS stack

This project is a CDK application used to deploy a fleet of Semaphore agents in your AWS account.

## Features

- Run self-hosted agents in Linux machines
- Dynamically increase and decrease the number of agents available based on your job demand
- Deploy multiple stacks of agents, one for each self-hosted agent type
- Access the agent EC2 instances through SSH or using AWS Systems Manager Session Manager
- Use an S3 bucket to cache the dependencies needed for your jobs
- Control the size of your agent instances and of your agent pool

Check out the [docs](https://docs.semaphoreci.com/ci-cd-environment/aws-support).

## Make these roles for Ansible

**Database:**

- Install PostgreSQL.
- Systematically disable PostgreSQL.
- Set up `/database` files.
- Copy/setup `database.yml` files for each environment.

**Git Configuration:**

- Clone specific repositories.
- Set up SSH for cloning with specific user credentials.

**Ruby & Rails Setup:**

- Install dependencies for Ruby installation.
- Clone and setup rbenv and ruby-build.
- Install and set a global Ruby version.
- Install railties.

**Node.js Setup:**

- Remove the existing version of nodejs.
- Check if `nvm` is already installed.
- Install `nvm` if it isn't installed.
- Update the profile file (`.bashrc`, `.zshrc`, or a message for other shells) with necessary `nvm` configurations.
- Install the desired version of Node.js.
- Set the default Node.js version and use it.

**Web Dependencies:**

- Install memcached and Redis.
- Install yarn.
- Other Node.js related tasks like `npx browserslist@latest --update-db` and `npm rebuild node-sass`.

**Application Setup:**

- Set up environment variables for AWS.
- Clean up and set up the application directory.
- Other application-specific tasks.
- Ensure ImageMagick is installed.
- Backup the existing policy XML (this is a good practice).
- Place the new policy XML in the required directory.

- **Logging & Cleanup:**

  - Set up and manipulate logs, such as the `resque.log` or the `cron.log`.

- **Other Tasks:**

  - Miscellaneous tasks such as creating directories, symbolic links, and others.

Now, for each of these roles, you would typically have the following directories and files:

- `tasks`: This will contain the main list of tasks that will be executed by the role.
- `handlers`: Contains handlers, which may be used by this role or even anywhere outside this role.
- `files`: This directory contains regular files which need to be transferred to the hosts you are configuring for this role. This may also include script files to run.
- `templates`: Contains template files which will be transferred to the hosts. Ansible uses Jinja2 templating here.
- `vars`: Variables for the roles.
- `defaults`: Default lower priority variables for this role.
- `meta`: Metadata for this role like its dependencies.

Given your setup, here's an example structure for the **Database** role:

```bash
database/
|-- defaults/
|   `-- main.yml
|-- files/
|   `-- ...
|-- handlers/
|   `-- main.yml
|-- tasks/
|   `-- main.yml
|-- templates/
|   `-- database.yml.j2
`-- vars/
    `-- main.yml
```

1. `tasks/main.yml` would contain tasks for installing PostgreSQL, setting up files, and other database-related tasks.
2. `templates/database.yml.j2` would be a Jinja2 template for your `database.yml` file, allowing you to dynamically configure it based on the environment or other Ansible variables.

By organizing your tasks in this manner and utilizing Ansible's capabilities to the fullest (like variable substitution, handlers for service restarts, and Jinja2 templating), you can ensure a more maintainable, reusable, and modular deployment setup.
