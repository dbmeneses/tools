# 1) make github token available:
#export GITHUB_TOKEN=token
# 2) copy this file to ~/.setup_sq
# 3) run: 
#       $ echo '. .setup_sq' >> ~/.profile 
#       $ . .profile

function _get_license() {
  echo `curl -s -XGET -H "Authorization: token $GITHUB_TOKEN" "https://raw.githubusercontent.com/SonarSource/licenses/master/edition_testing/${1}.txt" | sed -n 4p | tr -d '\\r'`
}

function _set_password() {
   echo "Setting password"
   curl --fail -XPOST -u admin:admin http://localhost:9000/api/users/change_password -d "login=admin&password=1234&previousPassword=admin" &> /dev/null || return 1
   curl --fail -XPOST -u admin:1234 http://localhost:9000/api/users/change_password -d "login=admin&password=admin&previousPassword=1234" &> /dev/null || return 1
}

function _get_edition() {
  local edition=$(curl -s -XGET -u admin:admin http://localhost:9000/api/navigation/global | jq -r ".edition")
  echo "$edition"
}

function _set_token() {
  echo "Creating token"
  export SONAR_TOKEN=$(curl -XPOST -s -u admin:admin "http://localhost:9000/api/user_tokens/generate?name=auto$RANDOM" | jq -r '.token')
  echo "Token (exported to \$SONAR_TOKEN): $SONAR_TOKEN"
}

function _set_license() {
  if [ -z "${GITHUB_TOKEN}" ]; then
    echo "No GITHUB_TOKEN set!"
    return 1
  fi

  echo "Setting license"
  local edition=$(_get_edition)
  echo "Edition: $edition"

  case $edition in
    "developer")
      local license="$(_get_license de)"      
      ;;
    "enterprise")
      local license="$(_get_license ee)"
      ;;
    "datacenter")
      local license="$(_get_license dce)"
      ;;
    "community")
      echo "Community edition doesn't need a license!"
      return 0
      ;;
    *)
      echo "Can't handle this edition"
      return 1
      ;;
  esac
  
  curl --fail -s -XPOST -u admin:admin http://localhost:9000/api/editions/set_license?license="$license" &> /dev/null || {
    echo "Unable to set license. Does the GITHUB_TOKEN have the repo permission and has SSO been configured for the token?"
    echo "License value: ${license}";
    return 1;
  }
  local is_valid=$(curl -s -XGET -u admin:admin http://localhost:9000/api/editions/is_valid_license | jq -r '.isValidLicense')

  if [ ! -z "$is_valid" ]; then
    echo "License set up successfully!"
    return 0
  else
    echo "License not accepted by SonarQube!"
    return 1
  fi
}

function setup_sq() {
 # set -o xtrace
  _set_password
  if [ $? -ne 0 ]; then
    echo "Failed to set password"
    return 1
  fi

  _set_license
  if [ $? -ne 0 ]; then
    echo "Failed to set license"
    return 1
  fi

  _set_token 
}
