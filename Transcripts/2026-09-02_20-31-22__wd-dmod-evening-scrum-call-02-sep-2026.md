---
title: "WD DMOD Evening Scrum Call 02 Sep 2026"
recorded: "2026-09-02 20:31:22"
context: "Kaushik, Shubham, Trinadh, Sharath, Abhay"
watch_for: "What are the open items from each person?"
duration_seconds: 1562
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Speaker 3": "Shubham (medium)"  # 9 min of speech
  - "Speaker 2": "Trinadh (medium)"  # 7 min of speech
  - "Speaker 5": "Abhay (high)"  # 3 min of speech
  - "Speaker 1": "Sharath (medium)"  # 2 min of speech
  - "Speaker 4": "unresolved"  # 2 min of speech
speaker_evidence:
  - "Speaker 3": "discusses IRGR table logic, incremental vs full load, data grouping, PySpark updates; technical content consistent with Shubham's work"
  - "Speaker 2": "discusses orchestration DAGs, helps Shubham with PySpark merge statement, debugs procurement job connection; manages multiple technical threads"
  - "Speaker 5": "addressed as 'Abhi' at line 192 by Speaker 2: 'Abhi, can you help us on that CDC testing documentation'; discusses DIMCPN reconcile"
  - "Speaker 1": "discusses CDC performance issues and full load timing; context lists Sharath, only remaining CDC-focused person"
  - "Speaker 4": "minimal speech with repetitive 'Okay' and 'Hi everyone' repeated lines; unresolved due to insufficient unique content"
status: summarized
---

## Transcript

**Speaker 1** · 00:00:00

Yeah, yeah, it went well, KaSyck.

**Speaker 2** · 00:00:23

Yeah, KaSyck.

**Speaker 3** · 00:00:30

Hi everyone. Hi everyone.

**Speaker 4** · 00:00:39

Hi everyone. Hi everyone. Hi everyone. Hi everyone. Hi everyone. Hi everyone.

**Speaker 1** · 00:01:16

Hi everyone. No KaSyck. The UOCDC is still in progress. Like that is taking long time to complete. I'm working on it. So far, I don't have any solution for that. No, it will take time, Ashik. No, no, no. CDC is not column by column. CDC is like, I'm checking.

**Speaker 2** · 00:02:01

If you continue focusing on that, I'll be able to close my orchestration today or maybe early tomorrow. And even if it is open, then we can work on that together. Can you share me the latest code on CDC itself?

**Speaker 1** · 00:02:23

Actually, I made some changes, but even for that also full load has completed in 34 minutes. Whereas incremental is taking still running, like it's almost 35 minutes, sorry, 26 minutes, no, still running. So I'll share the code with you. No, today it is not possible, I think, KaSyck, because CDC is taking a long time than full run. So, like, I'm trying multiple ways since morning, but none of them has worked. So, like, so this is like, if we have some, like, earlier we have column mismatches, right? So based on the number of columns, we can say this will take this much time. But now it is not a column problem or something. So whatever the CDC logic we have written is not working as expected. So today it won't be completed, that is for sure.

**Speaker 2** · 00:03:36

In orchestration, we have two jobs, KaSyck, the first one, it's complete, I was able to run it. But whenever the DIMCP and reconciled is fixed, let me know, I'll rerun the entire DAG once again. Sure, sure. Yeah. Currently, I'm looking into the second DAG project. I think I'll be able to close it in a couple of hours, if not today, then early morning or tomorrow. It was a working demo and, yeah, along with that, they've asked for one more DAG. I mean, I propose that myself that whenever they want to do a full load of any table, they can simply add those parameters in the DAG. I'll focus on that tomorrow. Should be closed in two, three hours.

**Speaker 4** · 00:04:58

No, no, no, KaSyck.

**Speaker 3** · 00:05:14

On the full load itself, there are some data mismatches which are coming up. A couple of them are silver issues, but for others, I could see the logic side, but I'm not able to find out what is the reason for mismatch. And they are not checking that data for any particular month. They are checking it for the entire filter, and that's where the row count is getting a huge mismatch. So I have asked Pani that I would need a copy of this table in AWS in order to run the minus query and give the final answer to quantify what exactly is the root cause. I'm checking with him on the same. On the incremental side, I made some modification, but I have one doubt that I would like to discuss with Sharath and Srinath in the call itself. So Sharath in IRGR table, once the data is loaded, they are updating the flag value based on the amount and quantity which are matching with the IR and GR data. So if I'm doing an incremental, that entire update on the amount needs to be run on the full data itself. That is the current table. Now in that case, if I only load the incremental data, and if I have to update this flag, I'll have to run another pipeline on the same. And from the PySpark, how do we update only those columns for the sake of it?

**Speaker 2** · 00:06:43

So in PySpark, the update command works, but again, can you show not reading the proper context? But again, if Trinath knows about this context, he can suggest. Yeah.

**Speaker 3** · 00:06:54

Yeah. So what is happening is that once we have the data, the logic that we have for the flag value is like this, that if for the group of receipt number and receipt line number, we are grouping it by them. And if the amount is matching, the good receipt amount is matching with invoice receipt and its quantity is matching with the invoice receipt quantity, then they mark it as closed. Otherwise, they'll mark it as MR open. And in another case, they are grouping it by the purchase order and purchase line order number. If in that case, again, if good receipt quantity and the amounts are matching, then they will call it as MO flag closed. So this currently as I'm doing full load, I'm able to update this flag value correctly. But with the incremental data, I will be only having the incremental records which is coming into picture, which will lose this context altogether. So, in that case, the incremental pipeline is not working for me. So I was thinking...

**Speaker 2** · 00:07:55

So, Shubham, in this case, from whichever column that you're getting this quantity, right? Or quantity, the amount... It's from the entire... Yeah. So basically, whichever column that you're using to join or basically match if it is coming as equal or zero. That corresponding silver table will also be read on an incremental fashion, right? So if a quantity value is getting changed, we read those records as well. And when we read those records, we are anyways applying this condition of matching the values, and it should come up right, correct? What I mean is, wait, this CTE IRGR is coming from the silver table.

**Speaker 3** · 00:08:46

It's not coming from the silver table. It's coming from the entire data that I'm creating for IRGR. So it's a combination of purchase order and invoice altogether. So there are two blocks of code for this, one for the GR data, one for the IR data, which are getting union all. And this is the approach of combining with the receipt line number and the purchase order number.

**Speaker 2** · 00:09:14

So... So here, what is the primary key?

**Speaker 3** · 00:09:17

The primary key is a combination of purchase order, a legal ledger entity, purchase order identifier, invoice distribution, and then receive transaction identifier, combination of this four column.

**Speaker 2** · 00:09:31

So in this case, currently, whenever you're trying to read the incremental CDC, then we try to get the list of IDs that got changed from all the tables, which ID is that. So basically where I'm going, I'll just take a minute to share my thoughts. Let's say in this case, you have this IR amount and you have a GR amount. Now IR amount is coming from one table, let's assume, and GR amount is coming from a different table. Now, for the first time, it's going to be a full load, so we'll have everything. In the second run, whichever is getting changed in the silver table, the date management, abated date time also is getting changed, right? So, and then let's say IR amount is getting changed, but not the GR amount. And what we do is we get the corresponding inverse distribution ID from the IR table. And then get all the records from the GR table for that ID itself. And then we load the data on an incremental basis. Right? So then if something gets changed in the silver, you automatically, anyways, apply that change in your incremental data also, right?

**Speaker 3** · 00:10:52

Yeah. So this is what the structure of the table would look like. So they don't have integration ID in their table currently, because it's a single-store table. They don't have this integration ID concept. So this is what my data would look like when I'm doing the incremental. So let's say earlier we had only four records in place and the next two got added, let's say from the incremental pipeline.

**Speaker 4** · 00:11:15

Okay.

**Speaker 3** · 00:11:16

Now, if in that case, what is happening is that we are doing a group buy on the receipt number and receipt line number in order to update those values. So what they look after is that they will refer to this previous row, IR quantity, and then they will club this GR quantity. Now, if this submission of these three rows and these two rows is coming exactly the same, they will say that for whatever the good receipt we got, we have done the payment of it. And they will mark all these six rows as MR closed. Now, if I'm bringing only the incremental data, I'll only have these two records to process.

**Speaker 4** · 00:11:51

Oh, I got you.

**Speaker 3** · 00:11:52

Yeah. Yeah. So the flag is getting updated on the entire dataset, not on the incremental record itself. Now, for this, to update the flag values, I will again have to create one script which is reading this entire data. And then for each combination of the integration ID, I mean, currently they are applying it on the, because I have the entire data in place.

**Speaker 2** · 00:12:16

So in this case, Shubham, you know, once you load the data, you can have another SQL down below, using which you can use update statement, right?

**Speaker 3** · 00:12:29

But if I run the update statement, I mean, I tried the merge statement in the Athena, and

**Speaker 2** · 00:12:39

it did not work, but it should definitely work in blue. Maybe Shubham, what I'm thinking is I'll, you can actually run it directly on glue itself. Because the syntax of Athena and the permissions that you get in Athena is completely different as compared to what you get in glue. Yeah. Okay.

**Speaker 4** · 00:13:04

Okay.

**Speaker 2** · 00:13:05

But, but sorry, but were you not able to run the update command?

**Speaker 3** · 00:13:12

I was not thinking of the same because the, I mean, there are multiple silver tables which are coming in this. So the current full load script is running under three minutes to load the entire data. I'm thinking that once I have the, the number of records are in millions, give you the count of the record.

**Speaker 2** · 00:13:33

It is in millions, but still closing in three minutes.

**Speaker 3** · 00:13:37

Yes.

**Speaker 2** · 00:13:38

How many, uh, source silver tables do we have?

**Speaker 4** · 00:14:08

So, I think that's a good question.

**Unattributed** · 00:14:38

I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question.

**Speaker 3** · 00:14:42

I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question.

**Speaker 4** · 00:15:18

I think that's a good question.

**Speaker 3** · 00:15:19

I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question.

**Speaker 2** · 00:15:55

I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I think that's a good question. I wanted to avoid. But see, in this case, one simple approach is once your table load is done, we can again write one more merge statement, or you can have a bit statement and that should work. But when you say it was not working in Athena, were you getting any error?

**Speaker 3** · 00:16:25

Yeah, I mean, I tried using merge statement directly. So saying you don't have permissions to run merge statements on this thing.

**Speaker 5** · 00:16:33

Can you run it on glue once?

**Speaker 3** · 00:16:36

Yeah, sure. I mean, yeah, I'll do. But once I'm done with this full load issues that I have, I'll run the same merge statement over there. I'll get the incremental record. I have all the incremental statistics. I'll take that also. Sure. Okay.

**Speaker 2** · 00:16:55

Okay. Okay. Okay. Abhi, I'm currently, I don't see the job funding for the same procurement. I don't know why, but let me debug that. If needed, I'll just call you up.

**Speaker 5** · 00:17:09

Okay. Sure, sure. I ran it for XLA invoice, you see.

**Speaker 2** · 00:17:15

I don't know. I don't think it's the glue issue. I think it's the air flow issue. For some reason, it's not able to connect to glue. I'll take a look. If required, we may have to change some configurations, but I'll get back to you on this, Abhi. Sure, sure. Thank you. Abhi, meanwhile, can you help us on that CDC testing documentation? Yeah.

**Speaker 5** · 00:17:37

Yeah. Yeah. So currently, I'm looking on dimcpn reconcile first. Sure. I'll try to close that because the issue was that we are using a stale copy in the QA also. So that is not returning the watermark map along with the incremental records as per the framework that we should. So that is causing it to fail. I have the root cause, but I have four or five versions of dimcpn together. I'm not sure which one is the latest, so it's some time to figure that out. But yeah, after that, I can start.

**Speaker 2** · 00:18:14

When you see you have four or five versions, I'm thinking if you want the latest one, you can get it from the S3 itself.

**Speaker 5** · 00:18:23

Yeah. So actually, the issue is that in ETM3, the earlier version which was working, there was one silver table that was there. But I guess silver team made some changes on the silver table when we moved to QA. It's item item, is it? Yeah. It was item item plus something later. So when we moved to QA, yes, we made the changes. So that changes are, I mean, that changes are, it's like different scripts should be needed for QA and then. Okay.

**Speaker 2** · 00:18:58

But we have a script available in the QA environment internally, right? We can't, we can't repeat it?

**Speaker 5** · 00:19:04

Yeah. So in the QA environment, the script that we had, as I said, like the structure is not correct as for the framework. Okay. I took it from the QA only, but the structure is like, it's not returning the watermark. So in the main file that we have, we are expecting watermark map also, even in case if it is a full name. So that, that is causing the job to fail. So yeah, I'm just checking like what, what, what's the least fix that I can do to make it done. Okay.

**Speaker 2** · 00:19:37

But I remember this way when I was looking for one of the table by mistake, I did not return both result as well as the watermark map. Even then the job ran and it was a full load every single time.

**Speaker 5** · 00:19:52

So that might be the, if that is in QA, I guess the framework that we had, I guess Shubham changed it right, Shubham for testing, I guess, in QA. So maybe due to that, it might work. If it is in depth. No, it wasn't depth.

**Speaker 2** · 00:20:10

I was working on the CDC for the one of the fact table. And by mistake, I had not added the result as, sorry, the return, the returning of result and the watermark map. I skipped watermark map, but still the job ran fine.

**Speaker 5** · 00:20:29

Okay. That is strange. I mean, that should not have happened. Yeah, it's the same thing and it's causing the issue.

**Speaker 2** · 00:20:40

Okay. That was when I think you had, you had been on leave, right? It was on that day. I think last Friday.

**Speaker 5** · 00:20:45

Yeah. Yeah. It's like, it is expecting two parameters in the main, but we, if we are returning one, it's like, it won't. Even in case if it is a empty dictionary, in the worst case, then also it should work. But if, if we are returning only one parameter, then, then that will not be.

**Speaker 2** · 00:21:04

Okay.

**Speaker 5** · 00:21:06

And that ideally should not work. I'm not sure why the answer will work. Okay.

**Speaker 2** · 00:21:11

I think it should be there in my notes. Which table was it? Just give me a minute. Okay.

**Speaker 5** · 00:21:20

Yeah. I'll, I'll check it. I'll try to check it as soon as possible. Sure.

**Speaker 2** · 00:21:26

If you need any help, you can have a working session just to see if there's a way to close it faster.

**Speaker 1** · 00:21:32

Sure. Sure. Sure.

**Speaker 3** · 00:21:55

That depends upon conversation with Connie, whether he will provide me the table in AWS or not. At least on the incremental part, I'll try to see again close today. I wanted to check where do we have test cases for full load and incremental. I guess incremental nobody has prepared, but do we have any test case document that we prepared for full load? Because Mary was asking me that is where we could find those test cases. So if we have it for full load, we can, you know, I can help her to find those test cases. Do you know where they have added these things so I can guide her to that? I guess I remember.

**Speaker 4** · 00:23:19

Okay. Okay.

**Speaker 3** · 00:23:49

You checked with her. I mean, she was telling that ideally we should complete everything today. And at least apart from me, everybody else should have their task completed. But I think we still have some more fun items to work on. So you can provide the status to Gayatri and let her know that at least we'll need one more day. can you stay on the call i need to we need to update some links on the conference page

**Speaker 4** · 00:24:25

okay okay

**Unattributed** · 00:24:39

you you you

