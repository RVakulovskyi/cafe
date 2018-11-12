<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>X4_month_reminder_to_send_speaker_pitch</fullName>
        <description>4 month reminder to send speaker pitch</description>
        <protected>false</protected>
        <recipients>
            <recipient>alice.reeve@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vanessa.gerber@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/X4_month_Conference_Reminder</template>
    </alerts>
    <rules>
        <fullName>Alice and Vanessa Email Reminders</fullName>
        <active>true</active>
        <booleanFilter>(1 or 2) and 3</booleanFilter>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>contains</operation>
            <value>Vanessa</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>contains</operation>
            <value>Alice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>Conference</value>
        </criteriaItems>
        <description>This is for Alice and Vanessa to get email reminders for tasks.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X4_month_reminder_to_send_speaker_pitch</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ActivityDate</offsetFromField>
            <timeLength>-120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email overdue Task</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>lessThan</operation>
            <value>LAST WEEK</value>
        </criteriaItems>
        <description>This is an email that is triggered when a task is 7 days overdue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Task.ActivityDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
