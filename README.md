Thesis template
=====

### Getting started

After [forking](https://help.github.com/articles/fork-a-repo/)
and/or cloning the repository, continue with the following.

#### 1. Step: Set up the repository.

You need to set the following points:
 - The `CODE_NAME` in `./CMakeLists.txt:7`.
 - The `repository` in `./scripts/fetch-code.sh:16`.
 - The `gitTag` in `./scripts/fetch-code.sh:10`.
 - Extend the`./scripts/install-deps.sh` your specific dependencies.

#### 2. Step: Fetch your code

```bash
./scripts/fetch-code.sh
```

#### 3. Step: Install dependencies

```bash
./scripts/install-deps.sh
```

#### 4. Step: Build code and paper

Build `pdf` and `code`.
```bash
cmake -H. -Bbuild
cd build
make
```

### For contibutors

`TODO:`
