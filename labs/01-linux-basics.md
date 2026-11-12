# Lab 1: Linux terminal basics (45 min)

## 🎯 Goals
- Move around folders and look at files from the terminal
- Create, edit and delete files
- Understand why DevOps engineers use the terminal so much

## 💡 Why the terminal?
Most servers in the cloud run **Linux** and have **no screen or mouse**. You control them by typing commands. Commands can also be saved in scripts and **automated**, and automation is the heart of DevOps.

How to read a command:
```
ls  -l   app
│    │    └── argument: what to act on
│    └── option/flag: how to do it
└── command: what to do
```

## 🛠️ Steps

### 1. Where am I? What's here?
```bash
pwd          # print working directory: where am I?
ls           # list files and folders
ls -la       # list ALL files (including hidden ones) with details
```

### 2. Move around
```bash
cd app       # change directory into "app"
ls
cd ..        # go up one level
cd ~         # go to your home folder
cd /workspaces/devops-roadmap-basics   # go back to the project
```

> 💡 **Tab completion:** type `cd ap` and press <kbd>Tab</kbd>. The terminal finishes the word for you. Use it all the time!

### 3. Read files
```bash
cat app/app.py            # print the whole file
head -n 5 app/Dockerfile  # first 5 lines
grep -n "route" app/app.py  # find lines containing "route"
```

### 4. Create, copy, move and delete
```bash
mkdir playground                 # make a folder
cd playground
echo "Hello Linux" > hello.txt   # create a file with text in it
echo "Second line" >> hello.txt  # >> adds to the end
cat hello.txt
cp hello.txt copy.txt            # copy
mv copy.txt renamed.txt          # move / rename
ls
rm renamed.txt                   # delete (no recycle bin, so be careful!)
```

### 5. Edit a file
In the terminal, run `code hello.txt`. The file opens in the editor above. Add a line, then save with <kbd>Ctrl</kbd>+<kbd>S</kbd>. Then:
```bash
cat hello.txt
```

### 6. Handy extras
```bash
history        # the commands you've typed
clear          # clean the screen (or press Ctrl+L)
whoami         # your user name
uname -a       # info about this Linux machine
df -h          # disk space
top            # live list of running programs (press q to quit)
```

### 7. Clean up
```bash
cd /workspaces/devops-roadmap-basics
rm -r playground     # -r deletes a folder and everything in it
```

## ✅ Checkpoint
Without looking at the steps, can you:
- [ ] show which folder you're in?
- [ ] list all files including hidden ones?
- [ ] create a folder, put a file in it, and delete both?

## 🏋️ Mini challenge
Count how many lines `app/app.py` has. *Hint:* `wc -l`

## 🆘 Troubleshooting
| Problem | Fix |
|---|---|
| `No such file or directory` | Check where you are with `pwd` and what's there with `ls`. Names are **case-sensitive** |
| Paste doesn't work | Use <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd> or right-click → Paste |
| Something is "stuck" | Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the running command |

➡️ Next: [Lab 2: Git & GitHub](02-git-basics.md)
