<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Trane_Deal_Team</fullName>
        <description>Alert Trane Deal Team</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>ben.dodge@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joe.euphrat@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nathan.whigham@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>cleanfund@cleanfund.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Web_to_Lead_Trane_v2</template>
    </alerts>
    <alerts>
        <fullName>CleanQuote_App_Completed</fullName>
        <ccEmails>h8s0k4d1n9z6y5n6@cleanfund.slack.com</ccEmails>
        <description>CleanQuote App Completed!</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CQ_App_Completed</template>
    </alerts>
    <alerts>
        <fullName>CleanQuote_Quote_Over_5MM</fullName>
        <ccEmails>k4x7j7h5o3j8s3b3@cleanfund.slack.com</ccEmails>
        <description>CleanQuote Quote Over $5MM</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CQ_Quote_Over_5mm</template>
    </alerts>
    <alerts>
        <fullName>CleanQuote_Quote_Under_5MM</fullName>
        <ccEmails>u3u6w7u5t3q7f1y5@cleanfund.slack.com</ccEmails>
        <description>CleanQuote Quote Under$5MM</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CQ_Quote_Under_5mm</template>
    </alerts>
    <fieldUpdates>
        <fullName>Prior_Stage</fullName>
        <field>Prior_Stage__c</field>
        <formula>PRIORVALUE( Lead_Stage_text__c )</formula>
        <name>Prior Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Stage_Duration</fullName>
        <field>Prior_Stage_Duration__c</field>
        <formula>PRIORVALUE( Stage_Duration__c )</formula>
        <name>Prior Stage Duration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UnCAPS_Last_Name</fullName>
        <field>LastName</field>
        <formula>Upper(LEFT(LastName,1))&amp;Lower(Right(LastName,LEN(LastName)-1))</formula>
        <name>UnCAPS Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Company</fullName>
        <field>Company</field>
        <formula>Account_Name__r.Name</formula>
        <name>Update Company</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_s_First_Name</fullName>
        <description>Separating First Name from Middle Name (if there is one character) and unCAPSing it</description>
        <field>FirstName</field>
        <formula>Upper(LEFT(FirstName,1))&amp;Lower(MID(FirstName,2,If(FIND(&quot; &quot;,FirstName)-2=-2,LEN(FirstName),FIND(&quot; &quot;,FirstName)-2)))&amp; 
If(FIND(&quot; &quot;,FirstName)-2=-2,&quot;&quot;, 
IF(LEN(FirstName) - FIND(&quot; &quot;, FirstName )==1,&quot;&quot;,Upper(MID(FirstName, Find(&quot; &quot;,FirstName),2))&amp; 
Lower(Right(FirstName,LEN(FirstName)-Find(&quot; &quot;,FirstName)-1))))</formula>
        <name>Update Lead`s First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_s_Middle_Name</fullName>
        <field>MiddleName</field>
        <formula>IF(LEN(FirstName) - FIND(&quot; &quot;, FirstName )==1,RIGHT(FirstName, 1),MiddleName)</formula>
        <name>Update Lead`s Middle Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CQ_App_Completed</fullName>
        <actions>
            <name>CleanQuote_App_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Application_Submission_Date__c=TODAY(),
OR(ISPICKVAL( CF_Lead_Source__c , &quot;Web Quote Owner&quot;),
ISPICKVAL( CF_Lead_Source__c , &quot;Web Quote Owner Rep&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CQ_Quote_Over_5mm</fullName>
        <actions>
            <name>CleanQuote_Quote_Over_5MM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Project_Size_In_Dollars__c &gt; 4999999,
OR(ISPICKVAL( CF_Lead_Source__c , &quot;Web Quote Owner&quot;),
ISPICKVAL( CF_Lead_Source__c , &quot;Web Quote Owner Rep&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CQ_Quote_Under_5mm</fullName>
        <actions>
            <name>CleanQuote_Quote_Under_5MM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Project_Size_In_Dollars__c &lt; 5000000,
OR(ISPICKVAL( CF_Lead_Source__c , &quot;Web Quote Owner&quot;),
ISPICKVAL( CF_Lead_Source__c , &quot;Web Quote Owner Rep&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Separate Middle Name</fullName>
        <actions>
            <name>UnCAPS_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_s_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_s_Middle_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Separating Middle Name from First Name (if Middle Name is 1 character) and unCAPSing whole First Name</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Track Prior Stage Info</fullName>
        <actions>
            <name>Prior_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Prior_Stage_Duration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Stage__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Company</fullName>
        <actions>
            <name>Update_Company</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Account_Name__c != null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
