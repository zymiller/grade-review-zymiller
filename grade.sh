CPATH=';lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

#|-grading-area
#|-student-submission
#   |-ListExamples.java
#|-lib
#|-grade.sh
#|-GradeServer.java
#|-Server.java
#|-TestListExamples.java


# Then, add here code to compile and run, and do any post-processing of the
# tests

#Checks if student submissions does include a ListExamples.java
set -e

listFiles=`find -name ListExamples.java`
if [[ -f $listFiles ]]; then
    echo $listFiles 'exists'
    cp $listFiles ./grading-area/
else
    echo 'No ListExamples.java file found'
    exit
fi

#Move all appropriate files to the grading area
cp ./TestListExamples.java ./grading-area/
cp -r ./lib ./grading-area

#Start grading and move directory to grading area
set +e

cd ./grading-area

#Checks if files all compile correctly
javac -cp $CPATH *.java
    if [[ $? -eq 1 ]]; then
        echo `javac -cp $CPATH *.java`
        echo "Did not compile properly"
        exit
    fi

#Sees if tests run without error
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-results.txt
    if [[ $? -eq 1 ]]; then
        echo `java -cp $CPATH org.junit.runner.JUnitCore TestListExamples`
        echo "Tests encountered an error"
    fi

# Checks if there are failures in the tests
grep 'Failures: ' test-results.txt
    if [[ $? -eq 1 ]]; then
        echo 'ListExample.java passed all tests'
    else
        grep -E '[0-9]) test' test-results.txt
    fi