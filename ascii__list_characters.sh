IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

source './bashFunctions/stringFunctions.sh'

echo "
    30 40 50 60 70 80 90 100 110 120
   ---------------------------------
  0:    (  2  <  F  P  Z  d   n   x
  1:    )  3  =  G  Q  [  e   o   y
  2:    *  4  >  H  R  \  f   p   z
  3: !  +  5  ?  I  S  ]  g   q   {
  4: \"  ,  6  @  J  T  ^  h   r   |
  5: #  -  7  A  K  U  _  i   s   }
  6: \$  .  8  B  L  V  \`  j   t   ~
  7: %  /  9  C  M  W  a  k   u  DEL
  8: &  0  :  D  N  X  b  l   v
  9: '  1  ;  E  O  Y  c  m   w
"

echo 'These outputs were generated using the below command:'
echo "man ascii | sed -n -E '/^[[:space:]]*2 3/,/^[[:space:]]*F:/p' | cut -c 25-"
echo
echo '(Note that `man ascii` takes a while to run the first time...)'
echo
