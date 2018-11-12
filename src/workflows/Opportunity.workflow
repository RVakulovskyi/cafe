<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Transaction_Manger</fullName>
        <description>Alert Transaction Manger</description>
        <protected>false</protected>
        <recipients>
            <field>Transaction_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Solar_City_Deal</template>
    </alerts>
    <alerts>
        <fullName>CQ_App_Completed</fullName>
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
        <fullName>CQ_Over_5MM</fullName>
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
        <fullName>CQ_Under_5MM</fullName>
        <ccEmails>u3u6w7u5t3q7f1y5@cleanfund.slack.com</ccEmails>
        <description>CleanQuote Quote Under $5MM</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CQ_Quote_Under_5mm</template>
    </alerts>
    <alerts>
        <fullName>Committed_deal</fullName>
        <ccEmails>d2w1c9u8w9t4y2y3@cleanfund.slack.com</ccEmails>
        <description>Committed deal</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Committed_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_Next_Step_Due_Today</fullName>
        <description>Email Alert Next Step Due Today</description>
        <protected>false</protected>
        <recipients>
            <recipient>ben.dodge@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>cleanfund@cleanfund.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Next_Step_Due_Today</template>
    </alerts>
    <alerts>
        <fullName>Executed_Initial_App</fullName>
        <ccEmails>d2w1c9u8w9t4y2y3@cleanfund.slack.com</ccEmails>
        <description>Executed Initial App!</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Initial_App_Alert</template>
    </alerts>
    <alerts>
        <fullName>LOI_Executed</fullName>
        <ccEmails>d2w1c9u8w9t4y2y3@cleanfund.slack.com</ccEmails>
        <description>LOI Executed</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Initial_LOI_Alert</template>
    </alerts>
    <alerts>
        <fullName>LOI_Transaction_Management_Alert</fullName>
        <ccEmails>transactions@cleanfund.com</ccEmails>
        <description>LOI Transaction Management Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>ben.dodge@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>danny.roberts@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LOI_Alert</template>
    </alerts>
    <alerts>
        <fullName>PACEPartner_has_created_an_opportunity</fullName>
        <description>PACEPartner has created an opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>ben.dodge@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chris.robbins@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PACEPartner_Portal_Opp</template>
    </alerts>
    <alerts>
        <fullName>PACEPartner_has_created_an_opportunity_BDEN</fullName>
        <description>PACEPartner has created an opportunity  - Brandon Bruce</description>
        <protected>false</protected>
        <recipients>
            <recipient>brandon.deno@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bruce.chandler@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PACEPartner_Portal_Opp</template>
    </alerts>
    <alerts>
        <fullName>PACEPartner_has_created_an_opportunity_JKAG</fullName>
        <description>PACEPartner has created an opportunity  - Joshua</description>
        <protected>false</protected>
        <recipients>
            <recipient>danny.roberts@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joshua.kagan@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PACEPartner_Portal_Opp</template>
    </alerts>
    <alerts>
        <fullName>SolarCity_New_Opp</fullName>
        <description>SolarCity New Opp</description>
        <protected>false</protected>
        <recipients>
            <recipient>brandon.deno@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chris.mckay@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>josh.smith@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.mustaro@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>renee.pifer@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PACEPartner_Portal_Opp</template>
    </alerts>
    <alerts>
        <fullName>Term_Sheet_Transaction_Management_Alert</fullName>
        <ccEmails>transactions@cleanfund.com</ccEmails>
        <description>Term Sheet Transaction Management Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>ben.dodge@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>danny.roberts@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.sadeh@cleanfund.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Term_Sheet_Alert</template>
    </alerts>
    <alerts>
        <fullName>Test_Rule</fullName>
        <ccEmails>testgroup@cleanfund.com</ccEmails>
        <description>Test rule</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LOI_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Expected_Revenue_Weighted</fullName>
        <description>Expected Revenue Weighted</description>
        <field>Expected_Revenue_Weighted__c</field>
        <formula>Financing_Amount__c *  Probability</formula>
        <name>Expected Revenue Weighted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Next_Steps_Update_Date_Time</fullName>
        <field>Next_Steps_Update_Time__c</field>
        <formula>now()</formula>
        <name>Next Steps Update Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Stage</fullName>
        <field>Prior_Stage__c</field>
        <formula>PRIORVALUE( Stage_text__c )</formula>
        <name>Prior Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Stage_Duration</fullName>
        <field>Prior_Stage_Duration__c</field>
        <formula>PRIORVALUE( Prior_Stage_Duration__c )</formula>
        <name>Prior Stage Duration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount</fullName>
        <description>(Update Amount)</description>
        <field>Amount</field>
        <formula>Financing_Amount__c</formula>
        <name>Update Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LOS</fullName>
        <description>Update the LOS to be 60 days from Initial App Executed.</description>
        <field>LOS_to_LOI_Date__c</field>
        <formula>Initial_App_Date__c + 60</formula>
        <name>Update LOS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PreQualified_Start_Date</fullName>
        <field>Pre_Qual_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update PreQualified Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quantity</fullName>
        <field>TotalOpportunityQuantity</field>
        <formula>1</formula>
        <name>Update Quantity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Committed Opp</fullName>
        <actions>
            <name>Committed_deal</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email to deal channel for committed app.</description>
        <formula>AND( 
ISPICKVAL(StageName,&quot;Committed&quot;), 
ISCHANGED( StageName) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email_PACEPartner_BDEN</fullName>
        <actions>
            <name>PACEPartner_has_created_an_opportunity_BDEN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( PACEPartner_Identifier__c ))  &amp;&amp;  OR( CONTAINS(PACEPartner_Identifier__c,&apos;001j000000YSGyd&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000khX8m&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000re5Eq&apos;)
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email_PACEPartner_CROB</fullName>
        <actions>
            <name>PACEPartner_has_created_an_opportunity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( PACEPartner_Identifier__c ))  &amp;&amp;  OR( CONTAINS(PACEPartner_Identifier__c,&apos;001j000000Sd0sR&apos;), 
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000khGar&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000j9ZVB&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000Wuxl0&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000Sd0ol&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000Vayxp&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000VZFSa&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000l9tk9&apos;)
)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email_PACEPartner_JKAG</fullName>
        <actions>
            <name>PACEPartner_has_created_an_opportunity_JKAG</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK( PACEPartner_Identifier__c ))  &amp;&amp;  OR( CONTAINS(PACEPartner_Identifier__c,&apos;001j000000WDrWj&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000WZrTL&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000kfQMd&apos;),
CONTAINS(PACEPartner_Identifier__c,&apos;001j000000ul7bA&apos;)
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Initial App Executed</fullName>
        <actions>
            <name>Executed_Initial_App</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_LOS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Email sent when Initial App is Executed</description>
        <formula>AND( 
ISPICKVAL(StageName,&quot;Initial App&quot;), 
ISCHANGED( StageName) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LOI Executed</fullName>
        <actions>
            <name>LOI_Executed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email sent when LOI App is Executed</description>
        <formula>AND( 
ISPICKVAL(StageName,&quot;Processing&quot;), 
ISCHANGED( StageName)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Transaction Manager</fullName>
        <actions>
            <name>Alert_Transaction_Manger</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Qualified Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sub_Lead_Source__c</field>
            <operation>equals</operation>
            <value>SolarCity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify User Next Step Due Today</fullName>
        <actions>
            <name>Email_Alert_Next_Step_Due_Today</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Alert_Next_Step_Due_Today</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Next_Steps_Tickler__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Ben Dodge</value>
        </criteriaItems>
        <description>Notifies User when an opportunity has a next step due today</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pre qualified Update</fullName>
        <actions>
            <name>Update_PreQualified_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(StageName), 
ISPICKVAL(StageName , &quot;Pre-Qualifed Lead&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SolarCityOpp</fullName>
        <actions>
            <name>SolarCity_New_Opp</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISBLANK( PACEPartner_Identifier__c ))  &amp;&amp;  CONTAINS(PACEPartner_Identifier__c,&apos;001j000000YSGyd&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Track Prior Stage Info - Opp</fullName>
        <actions>
            <name>Prior_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Prior_Stage_Duration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( StageName )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Amount Field</fullName>
        <actions>
            <name>Update_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>greaterThan</operation>
            <value>1</value>
        </criteriaItems>
        <description>Update the Amount Field based on the Total PACE Financing Amount Est.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Next Step Updated Date Time</fullName>
        <actions>
            <name>Next_Steps_Update_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(NextStep) || (ISNEW() &amp;&amp;  NOT(ISBLANK(NextStep)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Quantity</fullName>
        <actions>
            <name>Update_Quantity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Involuntary_Liens__c</field>
            <operation>notContain</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Update Quantity</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Weighted Amount</fullName>
        <actions>
            <name>Expected_Revenue_Weighted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Update Weighted Amount</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Alert_Next_Step_Due_Today</fullName>
        <assignedTo>ben.dodge@cleanfund.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Create Task for Next Step Due Today</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Alert: Next Step Due Today!</subject>
    </tasks>
</Workflow>
