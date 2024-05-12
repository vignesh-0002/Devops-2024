# Git Interview Questions:
### 1. What is Git? 
Git is a DevOps tool used for source code management. It is a free and open-source version control system used to handle small to very large projects efficiently. Git is used to track changes in the source code, enabling multiple developers to work together on non-linear development. 
### 2. How do you create or initiate a git repo? 
We can use the git init command to initialize a git repo.
### 3. Why do we initialize a repo?
The git init command creates a new Git repository. It can be used to convert an existing, unversioned project to a Git repository or initialize a new, empty repository. 
Most other git commands are invalid unless we are not initializing a repository, so this is usually the first command you'll run in a new project.
### 4. What is a repository in Git? 
A repository is a file structure where Git stores all the project-based files. Git can either store the files on the local or the remote repository. 
### 5. What is the difference between Git and GitHub? 
The key difference between Git and GitHub is that Git is a free, open-source version control tool that developers install locally on their personal computers, while GitHub is a pay-for-use online service built to run Git in the cloud. Git is a piece of software. GitHub is an online SaaS service.
### 6. What does git clone do? 
The command creates a copy (or clone) of an existing git repository. Generally, it is used to get a copy of the remote repository to the local repository. 
### 7. What is branching in Git? 
Git branches are effectively a pointer to a snapshot of your changes when you want to add a new feature or fix a bug no matter how big or how small you spawn a new branch to encapsulate your changes.
### 8. What is a merge in Git? 
Merging is a Git operation that integrates changes from one branch into another. It can be a fast-forward merge, where the target branch is updated to the latest commit of the source branch, or a three-way merge, where divergent branch histories are combined into a new commit. 
### 9. What is a conflict in Git? 
A conflict in Git occurs when two branches have made edits to the same line in a file or when one branch deletes a file while the other branch modifies it. Git cannot automatically resolve these changes; the developer must manually resolve the conflicts. 
### 10. What is a pull request?
A pull request is a proposal to merge a set of changes from one branch into another. In a pull request, collaborators can review and discuss the proposed set of changes before they integrate the changes into the main codebase.
### 11. What is `git fetch` vs. `git pull`?
The key difference between git fetch and pull is that git pull copies changes from a remote repository directly into your working directory, while git fetch does not. The git fetch command only copies changes into your local Git repo. The git pull command does both.
### 12. How do you revert a commit?
you have pushed a bad commit to GitHub or GitLab, the easiest thing to do is simply issue Git's revert command and push it back to the server
### 13. What is a `.gitignore` file?
The Gitignore. `.gitignore` file is used in a git repository to ignore the files and directories that are unnecessary to the project this will be ignored by the git once the changes as been committed to the Remote repository.
### 14. What is `git stash`?
The git stash command takes your uncommitted changes (both staged and unstaged), saves them away for later use, and then reverts them from your working copy. For example, $ git status On branch main Changes to be committed: new file: style. css Changes not staged for commit: modified: index.
### 15. What is `git merge --squash`?
#### ANS 1:
Squash merging is a merge option that allows you to condense the Git history of topic branches when you complete a pull request. Instead of each commit on the topic branch being added to the history of the default branch, a squash merge adds all the file changes to a single new commit on the default branch.
#### ANS 2:
The `git merge --squash` command consolidates all commits from a specified feature branch into a single commit when merging into the target branch, resulting in a tidier project history.
### 16. How do you resolve a merge conflict?
To resolve a merge conflict, edit the files to fix the conflicting changes. Then, use `git add` to stage the resolved files and `git commit` to commit the resolved merge.
### 17. How do you resolve a merge conflict?
To resolve a merge conflict, edit the files to fix the conflicting changes. Then, use `git add` to stage the resolved files and `git commit` to commit the resolved merge.
### 18. What is the difference between `git merge` and `git rebase`?
The main difference is in how the branch history is presented. `git merge` preserves the history of a feature branch by creating a new merge commit. `git rebase` rewrites the feature branch's history to appear as if it was developed from the latest main branch, creating a linear history.
### 19. Explain the Git branching strategy you use.
A common strategy is the Git Flow, which involves having a master branch, develop branch, feature branches, release branches, and hotfix branches, each serving a different purpose in the development cycle  
### 20. What is the purpose of `git cherry-pick`?
`git cherry-pick` is used to apply the changes introduced by some commits from one branch onto another branch.
