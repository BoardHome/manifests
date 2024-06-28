# Dog House Manifests

doghouse manifests repository

## XML Order Rules

* like branch:
  rk3288_next_20240628.xml ~ sdk development version + ***timestamp***
  rk3288_bsp_next_20240628.xml ~ bsp development version + ***timestamp***
* like tag:
  rk3288_release_v0.0.1.xml ~ sdk development version + ***version tag***
  rk3288_bsp_release_v0.0.1.xml ~ sdk development version + ***version tag***

## Usage

* pull source code:

  ***manifests stable branch:***

  `repo init --no-clone-bundle --repo-url https://gitlab.com/boarddogboy/doghouse/git-repo.git -u https://gitlab.com/boarddogboy/doghouse/manifests.git -m rk3288_bsp_release_v0.0.1.xml`
* update command:

  `.repo/repo/repo sync -c --no-tags`
