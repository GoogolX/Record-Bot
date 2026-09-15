---
title: "Morning Meeting with Supriyo to get QA Status of SIlver and Bronze Tables (VF)"
recorded: "2026-09-07 11:04:29"
context: "Kaushik, Supriyo"
watch_for: "Status of each tables across bronze and silver layers"
duration_seconds: 1135
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 10 min of speech
  - "Speaker 1": "?"  # 14 min of speech
status: summarized
speaker_evidence:
  - "Speaker 1": "Repeatedly mentioned specific tables and issues related to QA testing."
---

## Transcript

**Speaker 1** · 00:00:00

Hallo, hallo, hallo, hallo, hallo, hallo, hallo, hallo, hallo,

**Me** · 00:00:00

Hello. Hey, good morning. Yes, so I think I just want to go through all the defects in the bronze and silver layer right now, just one by one and just get a good idea of what is happening, what needs to be done so that we complete everything as soon as possible.

**Speaker 1** · 00:00:22

Okay.

**Me** · 00:00:26

I'll just share the tracker, maybe we can go table by table, okay, and if there are any tables that I've missed also, just let me know, because you are the one running the tests. Yeah, so for bronze, I see 8020 is still open, and there is a column count mismatch there, so where are we regarding that?

**Speaker 1** · 00:00:52

For that, let me confirm it one minute. Actually, I can confirm it because the min max value is same. So he said that if it's only one value in a complete column, then that's fine. It's just a placeholder column and it's something like that first October or something like that. So we can just ignore that and it will be fine. So this was confirmed by Atul.

**Me** · 00:01:23

Okay, I mean, can you just explain it to me?

**Speaker 1** · 00:01:27

If it's just the placeholder value, just like first October, first November, something like that. And if it's, okay, create system date.

**Me** · 00:01:39

Yes.

**Speaker 1** · 00:01:40

Okay, I was just confused with the other table. Let me see if it's the placeholder value or not, create system date.

**Me** · 00:01:50

Because there is a column here that is only in the source, not in bronze, so that...

**Unattributed** · 00:01:50

Yes. For create system date, he said again that if it's a placeholder value, then that's fine. Well, if it's not real. Yes.

**Speaker 1** · 00:02:01

For create system date, he said again that if it's a placeholder value, then that's fine. If it's not real. It's a bit distinct. Okay. Okay. This table was, I need to check if it's directly from source or not.

**Me** · 00:02:19

So you told me there is one other layer, we are not, when we are testing, we are not checking directly against the source. You are downloading from some landing layer.

**Speaker 1** · 00:02:30

This table was, I need to check if it's directly from source or not. 8020 right? Yeah, it's from dwh prod.

**Me** · 00:02:42

Okay, so do, can we check if this column got added because of the landing part, or if it is there in the source system as well, and it is missing in bronze?

**Speaker 1** · 00:03:00

Yes, that's what I'm texting, just a second. If it doesn't contain any meaningful data, then we can drop it.

**Unattributed** · 00:03:30

Okay.

**Me** · 00:03:39

Thank you.

**Unattributed** · 00:04:00

Okay.

**Me** · 00:04:09

You can check off time. Just make a note of this and let me know after this call.

**Unattributed** · 00:04:15

Okay.

**Me** · 00:04:15

So next table is cktimefl. In this, I saw that there is a date format. I mean, I don't even know if it's a format mismatch or I don't even know if those values are just placeholder values. Because source may it says 2001 0101 and then it says 00010101. So either place may it doesn't seem like it's meaningful data that is being used anyway.

**Speaker 1** · 00:04:30

Uh, which one for that?

**Me** · 00:04:39

So can we check this also? This is cktimefl, the one that I'm highlighting, row number 42.

**Speaker 1** · 00:04:44

CK. CK time FL. Okay. That division with, uh, yeah, I'll check that and I'll get it.

**Me** · 00:04:54

This one. You see the column, right? Effect details.

**Speaker 1** · 00:04:59

CK time FL. Okay.

**Me** · 00:05:00

Okay. So like, will you be able to check this or will you have to delegate to someone else?

**Speaker 1** · 00:05:01

Uh, but it, uh, but no, no, uh, I will check it. But the thing was, uh, this was already, I have already seen that, uh, it's just a formatting issue. Uh, yeah.

**Me** · 00:05:15

I mean, it's not about formatting. If the data is 2001 in source and 0001 in bronze, then somewhere in the, during the ingestion part, there is either a bug or it is that this column only is not useful and then we can drop it.

**Unattributed** · 00:05:29

Okay.

**Speaker 1** · 00:05:30

Okay. Yeah. Okay.

**Unattributed** · 00:05:33

Okay.

**Me** · 00:05:33

Okay. If so, if there is a bug, it needs to be highlighted and fixed. If this column is not useful or if it is this placeholder data, then we can just drop it and that is all this. So we, I check that way.

**Unattributed** · 00:05:34

Take it again. Okay.

**Speaker 1** · 00:05:36

Take it again. Okay. Take it again.

**Unattributed** · 00:05:39

Take it again.

**Speaker 1** · 00:05:40

For ingestion part, like what happened in, uh, DVD, uh, we need to raise it to the 520 if there is ingestion

**Me** · 00:05:47

So ingestion part, will you be able to check if there is a bug?

**Speaker 1** · 00:05:54

ball. Uh, I think it's an external day, not, not from Augusto, uh, uh, last time raised for that P

**Me** · 00:06:00

Okay. Do you know who is in the five-tran team?

**Speaker 1** · 00:06:11

underscore BG, uh, on the service now portal. Okay.

**Unattributed** · 00:06:17

Okay. Okay. Okay. Okay.

**Me** · 00:06:21

Okay. Then maybe I'll just check with Atul if it needs to be raised as a bug because I don't think it's a formatting issue.

**Speaker 1** · 00:06:21

Yes, you can check the turtle for this. But in any ways it was min, max, and average, all was one. So, yes.

**Me** · 00:06:27

If there is a formatting issue, there is something else. Like 2001 will not become just 0001, so. Yeah. Yeah. So there is only one value in the column, that means.

**Speaker 1** · 00:06:50

Yes.

**Me** · 00:06:51

So maybe that reference, maybe there is, maybe there is some reference date that is being added during the ingestion process and that is set to hardcoded to 0 or something.

**Speaker 1** · 00:07:03

Yes.

**Me** · 00:07:07

Okay. So this you're saying, uh, check with Atul.

**Speaker 1** · 00:07:11

Yes. Yes.

**Me** · 00:07:12

Okay. So it's 020, you will check this. I will check with Atul.

**Speaker 1** · 00:07:13

Yes. Yes. Yes. Yes.

**Unattributed** · 00:07:15

Yes. Yes. Yes.

**Me** · 00:07:18

Then, uh, this one, CF, CB, FT, LBR.

**Unattributed** · 00:07:18

Yes. Okay.

**Me** · 00:07:22

Okay, I show it. No, there is, it's there in bronze also, I think. Okay, why is this wrong? Okay, okay. Interesting. Um, so there is a row count mismatch. The, so I'm assuming this is like, uh,

**Speaker 1** · 00:07:49

Yes, probably.

**Me** · 00:07:51

sync issue. I mean, not a sync issue, but like, uh, we, like, we checked when the tables are not in sync.

**Speaker 1** · 00:08:00

Let me check out my latest round report.

**Me** · 00:08:00

So, yeah, like, when will you be able to check this?

**Speaker 1** · 00:08:07

Probably it was not there in the latest report so it got sent. TBFDLBR is not in the bronze checklist. It is in the silver. And it is not TBFDLBR. In silver layer, I just checked from silver layer to bronze layer, it is fixed. For the XRIF standard labour time pack.

**Me** · 00:08:52

Oh, okay, okay. So, yeah.

**Speaker 1** · 00:08:55

And the row count mismatch is fixed already on Friday night. No, XRIF table is on the silver layer. TBFDLBR is in the bronze layer and both are in silver now.

**Me** · 00:09:07

Okay. Okay, so silver to bronze you've checked, but CBF, DLBR, bronze to source, you have not checked.

**Speaker 1** · 00:09:18

TBFDLBR. No, that's the source. I have not it.

**Me** · 00:09:23

Okay, so then this needs to be checked, right?

**Speaker 1** · 00:09:25

Okay. But the initial list was only for the 45 tables, right?

**Unattributed** · 00:09:33

Because we are not saying for all the bronze layer tables.

**Me** · 00:09:35

This got added to the scope. Maybe we missed this earlier. Because even I noticed that this is not there earlier and then I added it later.

**Speaker 1** · 00:09:40

We are not saying for all the bronze layer tables.

**Me** · 00:09:42

So I thought you might have noticed that we might, we missed it earlier and added it to your checklist.

**Speaker 1** · 00:09:55

Initially, Shashvat said that only the 44 data confirmed. But three tables are only for checking. We are not even checking for the F0911 and F411 as the bronze layer table. Because they are still under the build. I'm not sure if we should check for the CBFDLBR. I don't know.

**Me** · 00:10:15

So, yeah, I think we have to go back to the top of the page.

**Speaker 1** · 00:10:18

You need to confirm it with Shashvat. Do we need to check with bronze layer? CBFDLBR. I don't know. Like, you need to confirm it with Shashvat. Do we need to check with bronze layer? CBFDLBR.

**Me** · 00:10:29

So, yeah, we have to go back to the top of the page. So, yeah, we have to go back to the top of the page. So, yeah, we have to go back to the top of the page. So, yeah, we have to go back to the top of the page. So, yeah, we have to go back to the top of the page.

**Speaker 1** · 00:10:39

For silver?

**Me** · 00:10:41

So, yeah, we have to go back to the top of the page. So, yeah, if it's not too much effort, then just add it to your list and check it out.

**Speaker 1** · 00:10:47

I need to confirm it with Mohit. Which source I need to check it with. Like fraud ASP, DWS fraud. Or there is a file. Then again, I'll have to ask for that file. If it is file-based stable.

**Me** · 00:11:01

So, yeah, we have to go back to the top of the page.

**Speaker 1** · 00:11:03

I'll take it. I'll take it. I mean, I'll take it. I'll take it. If you confirm and tell me, I won't have my efforts. Again, I'll take it.

**Me** · 00:11:11

Okay, no, my thought process is if it's being used in a silver table that we are anyway doing QA for,

**Speaker 1** · 00:11:11

I'll take it. The thing is, for silver layer,

**Me** · 00:11:19

then, of course, it would make sense that we should do QA at the bronze level also, right?

**Speaker 1** · 00:11:26

we are checking the code if silver is good or not. If silver table is good, and it is matching with the bronze, then it's fine. For bronze, we need to check with the source. It's a different path. So... If someone is there... Yes. Yes, yes.

**Me** · 00:11:49

So, as per that logic, then this will need to be QA, right?

**Speaker 1** · 00:12:01

Okay. Okay. But if you have a question about Shashwat, then I will ask them to ask them. The source of proof is what they have in this table.

**Me** · 00:12:17

okay take I'll go and okay let's go to silver silver you are only checking right

**Speaker 1** · 00:12:19

Yes. No, I am checking.

**Me** · 00:12:32

or is it at all okay can we start with this F55 AG BL I think there is a rock

**Speaker 1** · 00:12:35

AgDL is fixed.

**Me** · 00:12:42

on mismatch fixed okay rock on mismatch has been fixed okay can you send me the

**Speaker 1** · 00:12:42

It is fixed. Yes. I will share it in five minutes.

**Me** · 00:12:53

updated report also have whenever no hurry just make sure that it is

**Speaker 1** · 00:12:56

Okay. For silver layer, only four defects are remaining.

**Me** · 00:13:01

consolidated like it has information of all the bronze and silver tables for which overall checks have not passed yet you will I can send you a copy of this

**Speaker 1** · 00:13:09

And those four defects are F4, triple one, this one.

**Me** · 00:13:11

defect tracker so that is one thing and then just go through the defect egg bar and see if there is anything obvious that can be fixed before you send it to me

**Speaker 1** · 00:13:24

So the issue here is that I confirmed with the developer. In fact, the code is right. So there are some filters applied on the F4, triple one table. But the thing is, since JD, inventory transaction lot, it needs to be compared with DWH prod, not with F4, triple one. But the thing is, F4, triple one is still under work. So that's why we can't compare it to DWH prod because the data will not run and F4, triple one is still in development. So it will fail for now. PCS project.

**Me** · 00:14:08

each of them one is done so there's three remaining

**Unattributed** · 00:14:18

Just a second.

**Me** · 00:14:19

that is still open right can you just go through each of them one is done so there's three remaining

**Unattributed** · 00:14:21

Yes.

**Speaker 1** · 00:14:22

Let me find PCS project. What is the solution? Yes. So for PCS project, the issue is only two rows are, two rows mismatched. And I confirmed it with Mohit. The issue here is due to some joint conditions, those two rows will always, there will be always a difference of two rows. So this is, this should not be in the failed case. So.

**Me** · 00:14:55

Okay. All right. Then this one.

**Speaker 1** · 00:15:01

For DVAs, I confirmed with Mohit, the code is good. Only thing is, he said that there will be always, always some difference with DWH prod for some reason. So the code is also good for this, but it will fail.

**Me** · 00:15:19

Okay. So whatever, whatever this reason is, right? You need to document these and give them to me.

**Speaker 1** · 00:15:24

Yes. I will tag it in the group and Mohit will say the reason. DVB, DVB has passed. All clear. Yes.

**Me** · 00:15:38

Okay. So this has been fixed. Yeah. The naming.

**Speaker 1** · 00:15:41

Oh, no, no, no, not for column. Row count is, uh, fixed. Not for column. Uh, five print ticket is raised for this.

**Me** · 00:15:47

So, so this column problem is evident. All that needs to be done is not merge both these columns into one.

**Speaker 1** · 00:15:58

Oh. It is an automated process from five print. So for all the special characters get replaced by underscore. So what happening is, uh, in the source itself, it is a hash and dollar and both are getting changed to the underscore. So it needs to be fixed by the five printing. No row count is matching. So I have checked once when both the table were in sync. So most of the time the difference is 5-10 timing and DB2 timing are different. So most of the time there is a 10 or 20 rows difference. But I checked it when both were in sync.

**Me** · 00:16:20

So then we'll need to redo that once this is fixed. Okay. Okay. Sorry, sorry. Maybe I didn't mean row count. I meant row integrity.

**Speaker 1** · 00:16:45

Thank you.

**Unattributed** · 00:16:47

Thank you.

**Me** · 00:16:48

But row integrity we're not doing in silver. So okay. Okay. Okay. Okay. Then dvb needs to be raised to fat trend.

**Unattributed** · 00:16:56

Thank you.

**Me** · 00:17:02

What was the case with agbel? This you said is fixed. Okay. Then this you said is, it's, it's, it's, it will fail because of some known reason.

**Speaker 1** · 00:17:15

Two rows difference will be always there. Not with DBS. Actually we said the code is good but I'm not able to match the row count with the DWH broad. So maybe again due to sync issue but I'm checking whenever it gets synced I will say.

**Me** · 00:17:19

Okay. It's got the same dvs. Also. Okay. Okay. So this needs investigation. Okay.

**Speaker 1** · 00:17:43

Yes.

**Me** · 00:17:43

Dvs needs investigation. Dvv. Column count you have to raise to fat trend. Then CBF DLBR you said is fixed.

**Speaker 1** · 00:17:55

No it was a code issue and Friday night I almost fixed it.

**Me** · 00:17:56

So that was a sink issue here. Okay. Okay.

**Unattributed** · 00:18:05

Yes.

**Me** · 00:18:09

Okay. Cool. Can we do one thing? Can we just, uh, rerun or like, can you, can you share me a consolidated report of

**Unattributed** · 00:18:17

I will share it in five minutes with all the remarks.

**Me** · 00:18:19

everything that is open? Even if it is failed, that is okay.

**Unattributed** · 00:18:21

Yes.

**Speaker 1** · 00:18:22

I will share it in five minutes with all the remarks.

**Me** · 00:18:26

yeah, whatever details or information is needed and the bronze also.

**Unattributed** · 00:18:28

Okay.

**Me** · 00:18:32

I'll share this tracker with you.

**Speaker 1** · 00:18:33

Oh.

**Me** · 00:18:34

I'll share this tracker with you. Just let me know if you can accident. Okay. Inshallah.

