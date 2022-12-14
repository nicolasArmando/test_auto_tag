# author: jose.luis.lopez@wefoxgroup.com
# USAGE:
# ./vbump.sh [new_version]: will update the project to new version
# ./vbump.sh: (without arguments) will ask for input the new version and run the script
#
# FILES UPDATED
# - pom.xml files: this script runs the maven commands versions:set -DnewVersion=$newVersion and versions:commit,
# so all pom.xml files inside the project will be updated
# - ./docker-compose.yml: it will search for image: wefox/*:{old_version} string and will replace with the new version.

if [ -z $1 ]
then
  echo "New version:";
  read version;
else
  version=$1;
fi
if [ -z $version ]
then
  echo "Error: empty version not allowed";
else
  mvn versions:set -DnewVersion=$version;
  mvn versions:commit;
  mvn versions:commit -P post-deployment;
  sed -i -e -E "s/(image: wefox\/.+:)(.+)/\1$version/g" docker-compose.yml;
  rm docker-compose.yml-e;
fi