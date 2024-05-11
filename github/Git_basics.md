# Hello team welcome,
In this docs we are going to look into some basics of Git,
Without any delay lets dive into git basics.

## **What is Git?**

Git is a DevOps tool used for source code management. It is a free and open-source version control system used to handle small to very large projects efficiently.

## **why Git?**

Git is used to tracking changes in the source code, enabling multiple developers to work together on non-linear development.
- ## **How to install Git?**



   - ### Install Git on Linux
Fun fact: Git was originally developed to version the Linux operating system! So, it only makes sense that it is easy to configure to run on Linux.

You can install Git on Linux through the package management tool that comes with your distribution.

- ### Debian/Ubuntu
- Git packages are available using apt.
- It's a good idea to make sure you're running the latest version. To do so, Navigate to your command prompt shell and run the following command to make sure everything is up-to-date: 
   ```
    sudo apt-get update
   ```
- To install Git, run the following command: 
   ```
    sudo apt-get install git-all.
   ```
 - Once the command output has completed, you can verify the installation by typing: 
   ```
    git version
   ```

- ### Fedora
  - Git packages are available using dnf.
  - To install Git, navigate to your command prompt shell and run the following command: 
     ```
      sudo dnf install git-all.
     ```
  - Once the command output has completed, you can verify the installation by typing:
     ```
     git version
     ```
Note: You can download the proper Git versions and read more about how to install on specific Linux systems, like installing Git on Ubuntu or Fedora, in git-scm's documentation.


## Git official site link:

Please reffer the following link for git installation,

https://github.com/git-guides/install-git#install-git-on-linux

## How to create git directory
- Once git installed create a directory using:
```
mkdir git
```

- Now cd into the directory:

```
cd git
```
- use command:
```
git init
```
- use the above command to initialize the empty repository.
- You will get the following output.
![alt text](<Screenshot from 2024-05-11 12-24-31.png>)
## why we initialize a repo?

The git init command creates a new Git repository. It can be used to convert an existing, unversioned project to a Git repository or initialize a new, empty repository. Most other Git commands are not available outside of an initialized repository, so this is usually the first command you'll run in a new project.


## How to create and commit a file?

To create a file we used to follow the regular ways using vi or nano editor.

![alt text](<Screenshot from 2024-05-11 12-24-11.png>)

Now use `git status` command
![alt text](<Screenshot from 2024-05-11 12-30-44.png>)

- It is saying that you have one untracked file.which means your file is not added to the it repository's tracking index.
#### Git add
The git add command adds a change in the working directory to the staging area. It tells Git that you want to include updates to a particular file in the next commit. However, git add doesn't really affect the repository in any significant way—changes are not actually recorded until you run git commit.
- so to add your file to git repo you can use `git add`
command
```
git add .
git add <file_name>
```
OUTPUT:
![alt text](<Screenshot from 2024-05-11 12-36-22.png>)

See now our file is tracked by git.

#### Git commit

The git commit command is one of the core primary functions of Git. Prior use of the git add command is required to select the changes that will be staged for the next commit. Then git commit is used to create a snapshot of the staged changes along a timeline of a Git projects history.

- you can use `git commit -m "commit message"` command to commit your changes, on the commit message you can add the description of your commit.

![alt text](<Screenshot from 2024-05-11 12-43-38.png>)

#### Git logs:
If you want to check the history of commit or probably want to look back to see what happened use can use `git log` command to check the logs.
![alt text](<Screenshot from 2024-05-11 14-15-57.png>)

One of the more helpful options is -p or --patch, which shows the difference (the patch output) introduced in each commit. You can also limit the number of log entries displayed, such as using -2 to show only the last two entries.

![alt text](<Screenshot from 2024-05-11 14-20-38.png>)

This option displays the same information but with a diff directly following each entry. This is very helpful for code review or to quickly browse what happened during a series of commits that a collaborator has added. You can also use a series of summarizing options with git log. For example, if you want to see some abbreviated stats for each commit, you can use the --stat option:

![alt text](<Screenshot from 2024-05-11 14-22-59.png>)

But a more straightforward command to use is the command below, where you attach the oneline option:

![
](<Screenshot from 2024-05-11 14-29-06.png>)

To change the git file to its previous version ie. to revert back to previous commit we use following command:

```
git checkout 76df0b7dba36865fc62f0635ba12c657ee47f7a7 -- file1

git checkout < commit id of file we need to revert > -- < file name >
```
EX:
```
vignesh@vignesh-pc:~/git_demo$ ls
file1  file2
vignesh@vignesh-pc:~/git_demo$ git log
commit 291279fb6410bbaacc3bd2367f152bac36f466cd (HEAD -> master)
Author: vignesh-jumisa <vignesh@jumisa.io>
Date:   Sat May 11 14:51:53 2024 +0530

    commiting file2

commit 76df0b7dba36865fc62f0635ba12c657ee47f7a7
Author: vignesh-jumisa <vignesh@jumisa.io>
Date:   Sat May 11 14:11:55 2024 +0530

    this is mybsecond commit

commit 111094ca875c8c1f99e402ad091f63d4e23aca70
Author: vignesh-jumisa <vignesh@jumisa.io>
Date:   Sat May 11 12:43:35 2024 +0530

    this is my first commit
vignesh@vignesh-pc:~/git_demo$ cat file1
this is my first file
i have change this file

vignesh@vignesh-pc:~/git_demo$ git checkout 111094ca875c8c1f99e402ad091f63d4e23aca70 -- file1
vignesh@vignesh-pc:~/git_demo$ cat file1
this is my first file

```
on the above example we have file1 which the following conetent on the latest commit:

Author: vignesh-jumisa <vignesh@jumisa.io>
Date:   Sat May 11 14:11:55 2024 +0530

    this is mybsecond commit

commit:  `111094ca875c8c1f99e402ad091f63d4e23aca70`


```
this is my first file
i have change this file
```
- so we have reverted this to the previous version using following command:

`git checkout 111094ca875c8c1f99e402ad091f63d4e23aca70 -- file1`

this commit is from the first commit:
```
commit 111094ca875c8c1f99e402ad091f63d4e23aca70
Author: vignesh-jumisa <vignesh@jumisa.io>
Date:   Sat May 11 12:43:35 2024 +0530

    this is my first commit
```
so now when we cat this file we have following as a result:
```
cat file1
this is my first file
```
so this is how we can revert out commit to previos version.

# How to push our project to GitHub

### Step 1 – Create a GitHub account
Create a github account using the below link.
`
https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account
`

I already have a git_hub account so I am moving forward to next step.

### 
