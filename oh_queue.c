// DO NOT MODIFY THE INCLUDE(S) LIST
#include <stdio.h>
#include "oh_queue.h"

struct Queue oh_queue;

/** push
 * @brief Create a new student and push him
 * onto the OH queue
 * @param studentName pointer to the student's name
 * @param topicName topic the student has a question on
 * @param questionNumber hw question number student has a question on
 * @param pub_key public key used for calculating the hash for customID
 * @return FAILURE if the queue is already at max length, SUCCESS otherwise
 */
int push(const char *studentName, const enum subject topicName, const float questionNumber, struct public_key pub_key) {
    if (oh_queue.stats.no_of_people_in_queue < MAX_QUEUE_LENGTH && studentName != NULL) {
        struct Student newStudent;

        // Generate custom ID
        int customID[30] = {0};
        char plaintext[MAX_NAME_LENGTH] = {0};
        
        int index = 0;
        while (studentName[index] != '\0' && index < MAX_NAME_LENGTH - 1) {
            plaintext[index] = studentName[index];
            index++;
        }
        for (int i = 0; i < index; i++) {
            newStudent.customID[i] = customID[i];
        }
        plaintext[index] = '\0';
        index = pub_key.e;    
        hash(newStudent.customID, plaintext, pub_key);
        newStudent.queue_number = oh_queue.stats.no_of_people_in_queue + oh_queue.stats.no_of_people_visited;
        
        int k = 0;
        while (studentName[k] != '\0' && k < MAX_NAME_LENGTH - 1) {
            newStudent.studentData.name[k] = studentName[k];
            k++;
        }

        newStudent.studentData.name[k] = '\0';
        newStudent.studentData.topic.topicName = topicName;
        newStudent.studentData.topic.questionNumber = questionNumber;

        oh_queue.students[oh_queue.stats.no_of_people_in_queue] = newStudent;
        oh_queue.stats.no_of_people_in_queue++;
        // update status 
        OfficeHoursStatus(&oh_queue.stats);
        return SUCCESS;
    }
    return FAILURE;
}


/** pop
 * @brief Pop a student out the OH queue
 * @return FAILURE if the queue is already at empty, SUCCESS otherwise
 */
int pop(void) {
    if (oh_queue.stats.no_of_people_in_queue == 0) {
        return FAILURE;
    }

    for (int i = 0; i < oh_queue.stats.no_of_people_in_queue - 1; i++) {
        oh_queue.students[i] = oh_queue.students[i + 1];
    }

    oh_queue.stats.no_of_people_in_queue -= 1;
    oh_queue.stats.no_of_people_visited += 1;
    OfficeHoursStatus(&oh_queue.stats);

    return SUCCESS;
}


/** group_by_topic
 * @brief Push pointers to students, who match the given topic, to
 * the given array "grouped"
 * @param topic the topic the students need to match
 * @param grouped an array of pointers to students
 * @return the number of students matched
 */
int group_by_topic(struct Topic topic, struct Student *grouped[]) { 
    int num_students_matched = 0;
    int k = 0; 

    while (k < oh_queue.stats.no_of_people_in_queue) {
        if (oh_queue.students[k].studentData.topic.topicName == topic.topicName &&
            oh_queue.students[k].studentData.topic.questionNumber == topic.questionNumber) {
            grouped[num_students_matched] = &oh_queue.students[k];
            num_students_matched++;
        }
        k++;
    }

    return num_students_matched;
}


/** hash
 * @brief Creates a hash based on pub_key provided
 * @param ciphertext the pointer where you will store the hashed text
 * @param plaintext the originak text you need to hash
 * @param pub_key public key used for calculating the hash
 */
void hash(int *ciphertext, char *plaintext, struct public_key pub_key) {
    int n = pub_key.n;
    int e = pub_key.e;
    while (*plaintext) {
        int m = (int) *plaintext;
        long int current = 1;
        int k = 0; 
        while (k < e) {
            current *= m;
            if (current >= n) {
                current %= n;
            }
            k++;
        }
        *ciphertext = (int)(current % n);
        plaintext += 1;
        ciphertext += 1;
    }
}

/** update_student
 * @brief Find the student with the given ID and update his topic
 * @param customID a pointer to the id of the student you are trying to find
 * @param newTopic the new topic that should be assigned to him
 * @return FAILURE if no student is matched, SUCCESS otherwise
 */
int update_student(struct Topic newTopic, int *customID) {
    for (int i = 0; i < oh_queue.stats.no_of_people_in_queue; i++) {
        int match = 1;
        for (int j = 0; j < MAX_NAME_LENGTH; j++) {
            if (oh_queue.students[i].customID[j] != customID[j]) {
                match = 0;
                break;
            }
            if (oh_queue.students[i].customID[j] == 0) {
                break;
            }
        }
        if (match) {
            oh_queue.students[i].studentData.topic = newTopic;
            return SUCCESS;
        }
    }
    return FAILURE;

}

/** remove_student_by_name
 * @brief Removes first instance of a student with the given name
 * @param name the name you are searching for
 * @return FAILURE if no student is matched, SUCCESS otherwise
 */
int remove_student_by_name(char *name) {
    int found = 0;
    int name_length = my_strlen(name);
    int i = 0;
    while (i < oh_queue.stats.no_of_people_in_queue) {
        if (my_strncmp(oh_queue.students[i].studentData.name, name, name_length) == 0) {
            found = 1;
            for (int j = i; j < oh_queue.stats.no_of_people_in_queue-1; j++) {
                oh_queue.students[j] = oh_queue.students[j+1];
            }
            oh_queue.stats.no_of_people_in_queue--;
            oh_queue.stats.no_of_people_visited++;
            break;
        }
        i++;
    }
    if (found) {
        OfficeHoursStatus(&oh_queue.stats);
        return SUCCESS;
    } else {
        return FAILURE;
    }
}

/** remove_student_by_topic
 * @brief Remove all instances of students with the given topic
 * @param topic the topic you are trying to remove from the queue
 * @return FAILURE if no student is matched, SUCCESS otherwise
 */
int remove_student_by_topic(struct Topic topic) {
    int found = 0;
    int i = 0; 
    while (i < oh_queue.stats.no_of_people_in_queue) {
        if (oh_queue.students[i].studentData.topic.topicName == topic.topicName && oh_queue.students[i].studentData.topic.questionNumber == topic.questionNumber) {
            for (int j = i; j < oh_queue.stats.no_of_people_in_queue - 1; j++) {
                oh_queue.students[j] = oh_queue.students[j+1];
            }
            oh_queue.stats.no_of_people_in_queue--;
            oh_queue.stats.no_of_people_visited++; 
            found = 1;
            i--;
        }
        i++; 
    }
    if (found) {
        OfficeHoursStatus(&oh_queue.stats);
        return SUCCESS;
    } else {
        return FAILURE;
    }
}


/** OfficeHoursStatus
 * @brief Updates the "currentStatus" field based on
 * whether or not all students in the queue have been helped
 * @param resultStats A pointer the OfficeHoursStats variable
 * you are to update
 */
void OfficeHoursStatus(struct OfficeHoursStats* resultStats ){
    if (resultStats->no_of_people_in_queue == 0) {
        resultStats->currentStatus = "Completed";
    } else {
        resultStats->currentStatus = "InProgress";
    }
}

/*
 * Calculates (b^e)%n without overflow
 */
int power_and_mod(int b, int e, int n) {
    long int currNum = 1;
    for (int i = 0; i < e; i++) {
        currNum *= b;
        if (currNum >= n) {
            currNum %= n;
        }
    }
    return (int) (currNum % n);
}
