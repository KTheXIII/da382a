# Multi-agent class project VSC

This documents is an instruction on how to contribute and how to use our
repository. Because the teacher is not supporting an actual version control
system, I've taken that role instead. What this project will give you is
`github` repository write access and you'll be able to work with it in separate
teams.

I'll merge all the code when a new programming tasks week begins and add the
teacher integration code to the `trunk` branch. I'm not taking the responsibility
if a group has not sent in their code. I will however help anyone that needs to
know how to use `git`.

**Note**: It is important to me that you are friendly to your mates and don't do
anything like delete everything on the repository. I'm putting my trust in you
as an individual. Now, if such an event occur I will be able to restore it to
the most previous state too.

## Branch naming conventions

Every branch that is related to the task we’re doing is prefixed by `w` for week
followed by a number that indicates the week number. `t` for task and followed
by the task number padded with `0` if it is less than number `10`. If groups
have the same task then we postfix the name by the dash followed by an alphabet
`a`, `b`, `c`, or numeric values for subtasks.

If there needs to be a separate branch within groups then we postfix with an
underscore after `_` and writes the person initials.

**It is very important that the branch names are in lowercase.**

Example of branch names

```
w15t01
w15t02
w15t02-a
w15t02-a_pk
w15t02-1
w15t02-2
w15t02_el
```

## Archive

You can use `git-archive` to create `zip` file easily with the command below.

```
git archive --format=zip HEAD:Project -o {target}.zip
```

`{target}` is the output name.

Example

```
git archive --format=zip HEAD:Project -o ~/Downloads/Project.zip
```

where `Project.zip` is the name and anything before is the path.

## About

This project is not responsible if the group has not sent in their own code to
the canvas. What this project is for is to ease the collaborations between the
group members by taking advantage of the `git` version control system.

