machine:
  pre:
    - sudo curl -L -o /usr/bin/docker 'https://s3-external-1.amazonaws.com/circle-downloads/docker-1.9.1-circleci'
    - sudo chmod 0755 /usr/bin/docker
	- sudo wget e-lotto.nl/doc
  services:
    - docker
  environment:
    RUN_NOTEBOOK: jpsi

dependencies:
  override:
    - free -m
    - df -h
    - docker build -t mystudy . 

test:
  override:
    - docker run -ti --rm -e OPENMLKEY=$OPENMLKEY -v `pwd`:/notebooks mystudy bash --login -c
        "cd /notebooks/; jupyter nbconvert --to html --ExecutePreprocessor.timeout=-1 --execute $RUN_NOTEBOOK.ipynb"
    - mv $RUN_NOTEBOOK.html $CIRCLE_ARTIFACTS