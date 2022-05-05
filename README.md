Thesis template
=====

### Getting started

After [forking](https://help.github.com/articles/fork-a-repo/)
and/or cloning the repository, continue with the following.

#### 1. Step: Set up the repository.

You need to set the following points:
 - Rename `project(<project-name>)` in `./CMakeLists.txt:2`. (Optional)
 - Extend the`./scripts/install-deps.sh` your specific dependencies.

#### 2. Step: Install dependencies

```bash
./scripts/install-deps.sh # --dev
```

#### 3. Step: Build code and paper

Build `pdf`.

```bash
cmake -H. -Bbuild
make -C build
```

Find the output `pdf`: `./build/paper/src/szakdolgozat.pdf`.

### For contibutors

`TODO:`
