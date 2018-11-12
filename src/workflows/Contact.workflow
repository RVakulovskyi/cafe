<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mailing_City_to_Alt_City</fullName>
        <field>Alt_City__c</field>
        <name>Mailing City to Alt City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mailing_Street_to_Alt_Street</fullName>
        <field>Alt_Street_Address__c</field>
        <formula>IF(  ISCHANGED( MailingStreet ) , &quot;Match&quot; , &quot;Do Not Match&quot; )</formula>
        <name>Mailing Street to Alt Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>Update_First_Name</fullName>
        <field>FirstName</field>
        <formula>Upper(LEFT(FirstName,1))&amp;Lower(MID(FirstName,2,If(FIND(&quot; &quot;,FirstName)-2=-2,LEN(FirstName),FIND(&quot; &quot;,FirstName)-2)))&amp; 
If(FIND(&quot; &quot;,FirstName)-2=-2,&quot;&quot;, 
IF(LEN(FirstName) - FIND(&quot; &quot;, FirstName )==1,&quot;&quot;,Upper(MID(FirstName, Find(&quot; &quot;,FirstName),2))&amp; 
Lower(Right(FirstName,LEN(FirstName)-Find(&quot; &quot;,FirstName)-1))))</formula>
        <name>Update First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Middle_Name</fullName>
        <field>MiddleName</field>
        <formula>IF(LEN(FirstName) - FIND(&quot; &quot;, FirstName )==1,RIGHT(FirstName, 1),MiddleName)</formula>
        <name>Update Middle Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alt Address Update</fullName>
        <actions>
            <name>Mailing_Street_to_Alt_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Contact.MailingStreet</field>
            <operation>contains</operation>
        </criteriaItems>
        <description>Updates the Alt Address fields to match the Mailing Address fields when a Contact is uploaded through FullContact.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contact Address Mapping</fullName>
        <actions>
            <name>Mailing_City_to_Alt_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mailing_Street_to_Alt_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.MailingCity</field>
            <operation>notContain</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingState</field>
            <operation>notContain</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingStreet</field>
            <operation>notContain</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingCountry</field>
            <operation>notContain</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingPostalCode</field>
            <operation>notContain</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contact UnCAPS First Last Name</fullName>
        <actions>
            <name>UnCAPS_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Middle_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
