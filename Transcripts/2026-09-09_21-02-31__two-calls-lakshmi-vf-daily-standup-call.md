---
title: "Two calls - Lakshmi VF Daily Standup + Call with Tommy Wang on QA Progress"
recorded: "2026-09-09 21:02:31"
context: "Kaushik, Lakshmi, Ravi, Manjeet, Tommy, etc."
watch_for: "SUmmarise thoroughly"
duration_seconds: 5021
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 13 min of speech
  - "Speaker 5": "?"  # 25 min of speech
  - "Speaker 6": "?"  # 22 min of speech
  - "Speaker 2": "?"  # 14 min of speech
  - "Speaker 4": "?"  # 6 min of speech
  - "Speaker 3": "?"  # 3 min of speech
  - "Speaker 1": "?"  # 1 min of speech
status: summarized
speaker_evidence:
  - "Me": "Discussed the testing scope, defects, and report validation."
  - "Speaker 5": "Asked questions about testing scope, defects, and report validation."
  - "Speaker 6": "Provided detailed explanations on testing processes and timelines."
  - "Speaker 2": "Shared technical details of bronze and silver layers."
---

## Transcript

**Speaker 1** · 00:00:00

It's two weeks away from completing all our testing before we go into our regression suite after discussing with Rajeshwari in the column towards the end and sorry. Can you repeat that session again? I've updated the ETS for all the reports after discussing with Rajeshwari in the same sheet report. Great. Okay. So this is all for priority ones, right? Yeah. All for P1s. Okay. Yeah. I still see some blanks though.

**Speaker 2** · 00:00:42

So, let's see. The blanks could be for the red highlighted ones, I guess, Lakshmi. Can you check the report ones? Probably. You're right. No, not everything, but can we move the date column? Some are completed. Yeah. Oh, what happened? I can copy and paste. Okay. So, okay. Let's get, let's do one thing at a time. So, you're saying that anything that is okay and then there are two more for which we don't have. That's not a red, Rajeshwari. Okay. Okay. That we will check red. Yeah. Just check. Yeah. So, these ones, yes, I got your email. Let me check. So, that's given by Nagini Vijay, right? So, let me get back and then find the path for you. I think, I think we do have it. Let me confirm one second. I can give it to you right away. Because few reports. I think she already sent you the path. I mean, she already sent the path. Oh, here we go. Let me show you this email. Okay.

**Speaker 3** · 00:02:08

Probably, this will answer the question right away. Here we go. Oh, but looks like it's not for all, but some of the reports, like, we were not even able to find in the whole project.

**Speaker 2** · 00:02:23

Oh, it's, see, let me just go back here. All the reports that are in red. That could be for Canada. Sort by color, red. Okay. And then, you're talking about these reports, right?

**Speaker 3** · 00:02:37

Yes.

**Speaker 2** · 00:02:39

The Canada Desire. So, these are the links she sent me.

**Speaker 3** · 00:02:43

Those are five, I guess, for Canada. There are four or five links. Okay. Yeah. But tell me one thing, Lakshmi. Should we consider the reports which are in their personal objects and test them? These are all profile reports. Most of them are.

**Speaker 2** · 00:03:02

I don't think I can answer that question. Probably you, Manjeet, and Aravind are the experts in this.

**Speaker 3** · 00:03:09

Because in Release 1 and Release 2, we didn't test any objects which are present within the personal objects or personal folders. Yeah.

**Speaker 2** · 00:03:19

So, are you saying that all these reports are from personal folders?

**Speaker 3** · 00:03:23

Could be, because UST, that report I didn't even find. If you pass on me the links, right, I can check whether they're, where they're present and what exactly are they the same report I can check.

**Speaker 4** · 00:03:39

So, we, I don't think we want to test any personal reports. One, they have to be, you know, part of the regular standard project level dashboards, but that, the risk is it will add more scope. We can help them, you know, during UAT, they can test their personal, they can do the tests of their personal objects. If they run into some challenges, we can help them. So, testing personal objects, I think we shouldn't do, bring it into our scope.

**Speaker 2** · 00:04:14

Okay. Sorry, I got disconnected the last one, two minutes. So, are you saying, Manjeet, that personal, testing the personal folder, personal objects folders is challenging? So, what are you proposing?

**Speaker 4** · 00:04:27

We don't have visibility, we don't have visibility into those objects, that's one. Second, personal objects are like things that are in motion, right? So, the user might keep changing. Yeah. So, if you test something today, tomorrow, they might do something and there is no control. So, during UAT, they can try testing their personal objects and if they run into any challenges, we can help them. So, I think that's, I think that we can do, right, Radishri?

**Speaker 3** · 00:05:00

Yes, Manjeet, that we can do.

**Speaker 4** · 00:05:04

Yeah.

**Speaker 2** · 00:05:04

Okay. That is a fair thing. Okay. So, I think DC, these, all these reports that got added were added by Lin Shin Wang, sorry if I pronounce it incorrectly, and Nagini. So, she, let's get together. So, let me do one thing. Do you think having a call with them will, rather than going back and forth, I can schedule a quick call? Because I know Carlos asked his team members to provide the reports list of what needs to be tested and that's how we got this list added.

**Speaker 4** · 00:05:40

How many did we come to now, finally, the total number of reports?

**Speaker 2** · 00:05:43

It's 62. It has always been 62.

**Speaker 4** · 00:05:46

Okay. It's always been 62.

**Speaker 2** · 00:05:47

Yeah. It's been 62 since we did our planning call. So, let me do one thing, action item. I will schedule a call with these people and I'll see if I can add Rajeshwari. I'll try to find something in the morning, but if not, Manjeet, please make sure you have full inputs and then we can get together with Nagini, Lichin, I'll invite Carlos and then Arvind, Manjeet. So, we can then explain them why it is challenging and then we can align. Will that work, Rajeshwari?

**Speaker 3** · 00:06:24

Yes, Lakshmi, so that we can be clear that we are not testing the personal reports and all.

**Speaker 2** · 00:06:32

Yeah. And see, the communication should always come out in such a way that, hey, we are not testing, should not be the way.

**Speaker 3** · 00:06:38

We should tell them the challenges, which is why. So, I think it's always the wordings that we put in front of business, right?

**Speaker 2** · 00:06:44

Which will not escalate. If we say we are not, then that's like you're rejecting their request. That won't go well.

**Speaker 4** · 00:06:54

Sorry, not testing the personal objects, right? You're talking about personal objects still?

**Speaker 2** · 00:06:58

We need to explain why it's not possible to validate these.

**Speaker 4** · 00:07:04

Okay, I want to challenge that. Why will we say that we won't test the personal objects? And I don't see anything wrong in that. Because, see, setting the expectation is wrong, Lakshmi. A personal object is personal object of the user. If it is a project, then that is common at the project level. That is where the team can have visibility. Now, tomorrow, they can come up with some additional personal objects. And it's, I think it's not better to…

**Speaker 2** · 00:07:34

That is what you should explain. That's what you need to explain.

**Speaker 4** · 00:07:36

Yeah, any assumption that, like, we shouldn't be explaining to them that we'll not be testing these personal objects. They should know that personal objects are out of scope, straight away.

**Speaker 2** · 00:07:46

Yeah, just explain them the challenges of why these cannot be tested. Okay, let's move on. So, I will take that as an action item, Rajeshwari, and I will get this sorted for you. So, other than these reports, anything else, I see some colors. I don't know what these yellows mean.

**Speaker 3** · 00:08:03

I don't know. From the beginning, it was in the yellow, Lakshmi.

**Speaker 4** · 00:08:06

Shivam added them earlier. I think you can remove them.

**Speaker 2** · 00:08:12

Okay, because you're the owner of this entire sheet, Rajeshwari. If you are aligned, you're aligned. If you're not aligned, you're not aligned.

**Speaker 3** · 00:08:19

Yellow ones, I was not sure. Red, I have highlighted it because those are the ones which I have colored it because I was not able to find those reports. Yellow ones, I'm not sure if it is added by some business users.

**Speaker 2** · 00:08:32

So, these ones should be confirmed by Andy. I sent him an email. So, let's see. Okay. And then, I know there's green ones. Manjit is grouping them.

**Speaker 4** · 00:08:42

Oh, no, Lakshmi. Rajeshwari was going to continue on that. I started, I showed her. So, Rajeshwari, did you get a chance to group them yesterday?

**Speaker 3** · 00:08:51

I think I have tried something. I'll sync up with you on that, Manjit.

**Speaker 4** · 00:08:56

Okay. Okay. Yeah, but we'll get it done, Lakshmi.

**Speaker 2** · 00:09:01

Okay. So, we only see 59. I thought 62 will remove unknown reports. Why the count is not matching?

**Speaker 3** · 00:09:17

Any other filters are applied?

**Speaker 2** · 00:09:20

Probably the completed filter in the end. Okay. 66. Okay. Now, I see 66.

**Speaker 3** · 00:09:34

Could be because of TBC.

**Speaker 2** · 00:09:36

No, TBC is always considered because we don't know if it is going to be a one or two, right? 66 is there. And even TBC, it is three. It should be 63. But I only see 62 here. 63. Okay. That's good. Okay. I think we're fine. All right. So, Rajeshwari, any other challenge? The only challenge I'm hearing from you is find me an answer to this. Anything else?

**Speaker 3** · 00:10:02

Other than that, I think I have a few issues with the table level permissions things, which I'll work with Manjit on that.

**Speaker 2** · 00:10:10

Okay. So, that's all internal, right? So, nothing to pay?

**Speaker 3** · 00:10:15

Yes. Nothing to pay?

**Speaker 2** · 00:10:15

Okay. And let me ask you guys, if I'm sending an email, tagging your names, please respond to those emails. I haven't heard from Manjit and Rajeshwari since some time after sending reminders on this. One second. Let me just send you that, give you that email. So, this is about this email I'm referring to. There is, they're struggling for the validation owners. The business team doesn't have a clue who is testing what and who is owning what. So, I've asked to send me ownership.

**Speaker 3** · 00:10:53

Oh, I think the owners. I checked this one, Lakshmi. I think I missed to send that reply. What I see, the owners as admin. I can't backtrack this, who have created the report. Even I did check the change journal and all. I don't know who are the owners of this report.

**Speaker 2** · 00:11:10

Reply that.

**Speaker 3** · 00:11:10

I checked this one. Yeah, yeah. I forgot to reply, but I've checked it.

**Speaker 2** · 00:11:14

Probably we'll end up having them descoped. If there is no one working on it, then we probably... And once again, those are P2s. So, we are not testing those. But if business is supposed to be testing that we aligned on with them, it will be a... We don't want them to get back to us saying that, hey, we've asked for this response. You did not give us a response and we will not sign off you. We don't want to end up in that situation, right? So, just close the loop.

**Speaker 3** · 00:11:39

Yeah, I'll reply on top of it.

**Speaker 2** · 00:11:41

So, if you say that there is no owners, etc., then I can ask, hey, can we just remove them out of scope? That will be my follow-up question to your email.

**Speaker 3** · 00:11:49

Okay.

**Speaker 2** · 00:11:50

Yeah. Can you please do it today?

**Speaker 3** · 00:11:52

Sure, sure.

**Speaker 2** · 00:11:53

Thank you. I normally tag Manjeet on these emails because Rajeshwari, you're offshore, right? So, but please make sure any reporting questions, you're the primary owner. And if you're not able to provide your responses before your end of day, the expectation is you need to hand it off to Manjeet.

**Speaker 3** · 00:12:12

Yeah, I read this and I did check that, but I missed to reply. Let me reply. Yeah, please do that.

**Speaker 2** · 00:12:17

Thank you. The next one. Okay, let's move on. So, and then last question to you, Rajeshwari. So, are you confident that you will be able to complete all the development work by 17th of September? Everything. I see some of them are for 19th as well.

**Speaker 3** · 00:12:40

Yeah, it depends on when they are going to provide the table.

**Speaker 2** · 00:12:43

19th is a Sunday, Saturday. So, are you working on a Saturday too to complete this?

**Speaker 3** · 00:12:47

Most probably they would have given a buffer, Lakshmi. Before that only I'll be getting it. If I get all the tables on time, definitely I'll be able to complete this.

**Speaker 2** · 00:12:57

No, no, no. That's not the response. That's not acceptable response. Now, let me ask Shashwari. So, Shashwari, when Rajeshwari is coming up with a timeline, the expectation that Rajeshwari will have is the tables will be complete on time, right? So, whoever is developing those tables should be committing to you to give those timelines, right? So, no more ambiguity, guys. We had in the last two weeks. So, please give me an answer which is valid. Even if it is taking longer, that's fine. But give me the right answer, which cannot be changed.

**Speaker 1** · 00:13:30

So, Lakshmi, so I've entered the ETA after discussing with developers and Rajeshwari both. So, at least for the repointing part of it.

**Speaker 2** · 00:13:40

Okay. So, I see that most of the tables are moving towards 17th September, but I highly doubt QA team is getting enough time to test because if we are expecting everything to be done by 21st, when will QA complete their validations? Where is the QA timeline for these? I only see development, but what about QA?

**Speaker 1** · 00:14:11

Sure, we'll add that as well for QA discussing with Kaushik.

**Speaker 2** · 00:14:16

Yeah, but that's the ask, right, Shashwari? But to give me the timelines for both. So, can we get it by tomorrow, please?

**Speaker 5** · 00:14:24

Sure, sure, sure.

**Speaker 2** · 00:14:25

Yeah, just exactly like how you did for the, you did a great job for these layers. So, that's the same thing you have to do. Replicate the same exercise for reporting as well.

**Speaker 1** · 00:14:37

Sure, sure.

**Speaker 2** · 00:14:38

Yeah, thank you. So, Kaushik, do you want to give you your updates for the QA, please?

**Me** · 00:14:48

Yeah, sure. So, there is still one defect that is open, and this is a common defect across both silver and bronze. And this has more to do with a limitation with the ingestion tool itself. And we have raised a request with the FiveTran team, and our team is also looking into alternative fixes. This should be done soon enough. It's just that we are also waiting for a response from the FiveTran team.

**Speaker 3** · 00:15:14

Okay.

**Speaker 2** · 00:15:14

So, who is following up with the FyTrend team proactively?

**Me** · 00:15:18

This is Atul.

**Speaker 2** · 00:15:20

Okay.

**Speaker 3** · 00:15:21

Yeah, if you're stuck for anything, don't leave it to last minute.

**Speaker 2** · 00:15:25

Please involve Arvind, Heidi or myself and in order to expedite it. But I haven't worked with FyTrend team. So, probably it will be mostly Arvind in this case to help expedite it.

**Speaker 6** · 00:15:36

So, just to double click on that, Lakshmi and Arvind also, this is the issue is that it's a setting, it's a functionality of the tool itself. It's not a defect on their part. It is how the connector is set up. So, now in this current connector, we cannot change that setting because if we change that setting, it cannot be changed as part of their functionality. So, we have to create a new connector to handle this and next new connector means that we just have to create another connector where just one table is running. So, we are just evaluating options as to how to proceed. At the same point of time, we are proceeding with our next steps on this particular table because there is a high probability some of these two columns that we are talking about. These might not be even utilized in any of the reports or downstream tables. So, we are anyway evaluating that and we are proceeding with that whether this column is being utilized anywhere or not. But larger thing is that we will have to figure out whether we want to create, meaning we will have to create a new connector, next new connector, but it might just be an overkill to create a new connector for this one table. So, we are just looking at those options. As per current status, there's nothing pending from FyTrend. Okay, it's a functionality of there. Okay, got it.

**Speaker 2** · 00:17:01

Okay. So, the next question is for the gold development. So, I know 74% has been deployed and 7% has been validated. So, let's see. So, do we have dates for QA completion as well? I think it's still. Yeah. So, Shashwat, can you please go ahead and add columns for QA for both gold and reports?

**Speaker 1** · 00:17:32

Sure. I'll add for gold there.

**Speaker 2** · 00:17:35

So, Kaushik, please work very closely with Shashwat and Ravi to get that completed, to get those listed. Because I think at the end of the day, everyone's focus will be on QA. Okay. So, let's have those. But I'm asking you the question that I ask every day. Do you see any risk of completing your QA, which includes gold and report testing by 21st?

**Me** · 00:18:07

Not as of now, Lakshmi.

**Speaker 2** · 00:18:09

Are you sure?

**Me** · 00:18:09

This should be on track because we're onboarding Arun as well and we'll have Arun Rajeshwari

**Speaker 2** · 00:18:16

Okay.

**Me** · 00:18:17

and maybe one developer as well who might be helping us with this.

**Speaker 2** · 00:18:23

Okay. So, you're planning to expedite it? Okay. So, that will give you room for your QA to complete by 21st.

**Me** · 00:18:29

Yes.

**Speaker 3** · 00:18:31

Okay.

**Speaker 2** · 00:18:32

So, I'm taking that as a positive thing. But please, see, it's okay to raise risks. But don't leave it to last minute. That's my only request. Okay. And then, so, Ravi, overall, do you feel confident that we'll be able to wrap up everything as per the scheduled time? Because the last 10 days of when the team is performing regression, I want to work with you guys to make sure that we are having our communication plans. Cutover plan might be too early, but then we just want to start putting things together so that we have enough time for reviews with the leadership teams. Because that is a time that takes longer, right?

**Speaker 6** · 00:19:17

Yeah, yeah.

**Speaker 2** · 00:19:19

I want to keep it to be out of the way.

**Speaker 6** · 00:19:21

Yeah, I think we should be good because most of these tables that I see here, they are being done in a group. So, for example, if you see the PVV tables, right? Those are a bunch of six, seven tables which are being done together. So, they will be getting done at one single shot. Oh. By that, I mean that these are all interrelated. So, as we are developing, you know, it is creating the, you know, base tables for the subsequent table also. So, it is going to get done in that way. And then there are a few which are, I think, views which are pending. So, primarily, the domain where work is pending is time and labor and finance. Finance, we are on track. Time and labor is one where there's a lot of old Kronos files, Ceridian files, everything involved. But we should be able to close that off. So, from a tables perspective, I think we should be good. The good part is, since we are running everything in production data and most of the reports have both R1, R2 and R3 tables. So, you know, it kind of covers a lot of the regression and performance aspects as well. And we are also getting some feedback from the DataOps team on specific oil trading reports or LB dashboard kind of reports which we want to focus on when we are doing the testing. So, you know, what we are seeing in production today, right? So, I think from a regression and performance perspective as well, even though we are slated to start from one or two weeks later, I think as part of this testing, we are anyway touching, you know, parts of that. So, I think overall, I'm good, even if we end up, I don't think it should happen, but even if we end up one or two days extra here and there, we should be good. Okay.

**Speaker 2** · 00:21:16

Okay. I'm fine. I mean, I'm fine as long as you guys are very confident about completing it on time. So, the repointing status is just another question. So, the repointing status is at table level, which is 49%. And this is just the P1 reports, which is 62%. And then the overall is 34%. So, Rajeshwari, you told me that you will be able to complete the repointing for all reports by in the next one or two weeks, right? Not even two weeks, like in the next one and a half week.

**Speaker 3** · 00:21:47

Yeah, next one and a half weeks, yes. Okay, perfect.

**Speaker 2** · 00:21:51

Yeah. So, tomorrow morning, please make sure we have columns clearly. And then please move this column towards the left, Shashwat. So, one column is for development and one column is for QA.

**Speaker 1** · 00:22:07

Sure, we'll add that.

**Speaker 2** · 00:22:09

Yeah, for both gold and report. So, we know that. See, and then if there are tables which you're still not confident about completing it on the scheduled time, it is okay. But give the time that you need so that we know, hey, there are some challenges, totally understandable, and we'll work through it. Sure. And the other thing is, we will not be going into UAT for finance until 19th of October. So, you definitely have extra time for finance stuff.

**Speaker 1** · 00:22:41

Okay.

**Speaker 2** · 00:22:42

But please make sure all the other domains are complete by 21st. But finance, you can take that extra few days if you need it.

**Speaker 5** · 00:22:51

Okay.

**Speaker 2** · 00:22:53

Okay. So, the other question to Manjit. I know you sent an email to Andre. Is it Andre? So, did you get a response, Manjit, on that for time and labor?

**Speaker 4** · 00:23:06

Yeah, so he sent out an email to Denny to confirm on that, that the old Kronos data file is no longer needed. Once we get confirmation, we can proceed. But as of now, we are proceeding with an assumption that we don't need to do any development for that file because it is on-prem Kronos data, and it is the same data that is being loaded every day. So, we are going to do it as a one-time thing.

**Speaker 2** · 00:23:36

Okay. Perfect. So, you don't have any more open items, right?

**Speaker 4** · 00:23:40

Not on that. But is Arvind there? Yeah. Okay. So, Arvind, so what we are planning to do, okay, I have to, you know, just maybe at a high level get the design finalized, Lakshmi. So, I'll wait for the end of the call. So, you can complete your items. Yeah.

**Speaker 2** · 00:24:01

Okay. No, I think I'm pretty much okay. I don't see any, at least I'm not hearing from you guys about any major blockers or anything as such. But, Kaushik, we do have a call at 9 o'clock with Tommy. So, I'm sure you're ready to show all the results and walk through the results with him. And then we can close that aspect as well, the QA aspect. Okay. And then, yeah, I don't have any other open questions, but I will get some answers over to you, Rajeshwari, for those red items.

**Speaker 3** · 00:24:38

Thank you, Lakshmi.

**Speaker 2** · 00:24:40

Okay. Over to you, Manjeet. I will be dropping off at 9 o'clock with Kaushik.

**Speaker 4** · 00:24:45

Okay. Okay. So, Arvin, I was creating a flow on the approach that we will take for this TMS data. I'm just connecting back to the Lucid chat. Okay. So, let me share my screen. Okay. Do you see my screen?

**Speaker 5** · 00:25:26

Yes. Yep. Okay.

**Speaker 4** · 00:25:28

Okay. So, what I'm proposing for the employee dimension table, we initially thought that the table that we built for Aspart of People Analytics was good enough for us to use for our release three. But after doing more research on that and also confirming with Monica a couple of weeks ago, we see that there is data beyond success factor because the data in paper analytics is only success factor. So, we have to get chrono. So, this is what I'm proposing. So, this is what I'm proposing. So, the on-prem thing, I sent out an email to Andre to confirm that because it is an on-prem and it is no longer being used, we'll just go do a one-time load and then introduce a new table in the time and labor schema, which I'm calling it as DIM employee TL. So, this is a separate table purely for the time and labor dashboarding that there will be one-time load for this on-prem data. Then, from WFT and Ceridian, we'll build the ETL pipelines just like we have it in DB2 and they will be added into this. Then, for success factor, I did the analysis on the pipeline. So, from success factor, only the company code 102, which is Canada data, right? So, that is being fetched. So, what we do is we'll pull the data from the current people analytics table and here only the employee name and other non-sensitive data is used. To be honest, when I looked into the reports, except for the employee name, there are only like three, four attributes, not even beyond that. So, the employee name and the shift code and then the pay type code sort of columns. So, we'll make them available and then this entire data will be loaded into this DIM employee TL table and this will serve as the employee dimension table in the time and labor scope. So, that this will be completely segregated from the DIM employee table that we built as part of people analytics. Sure.

**Speaker 1** · 00:27:52

So, currently, this table is called as...

**Speaker 3** · 00:27:58

Hi, Kavsheik.

**Me** · 00:28:14

Hey, hi, Lakshmi. Hey, hi, Lakshmi.

**Speaker 2** · 00:28:18

Yeah, I will be dropping off in the first few minutes. I just want to wait for Tommy. And then, since I think this is your first call with Tommy, right? Yeah, I just want to make sure that Tommy, I just do the introductions and then you guys can proceed. Hi, Tommy.

**Speaker 5** · 00:28:47

Hello. Hey, Lakshmi. Hello. You're a Kavsheik, right? Okay. Sorry.

**Speaker 2** · 00:29:03

Yeah. So, hi, Tommy. So, thanks for joining. So, I just thought, you know, I'll just introduce you, Kavsheik, to you. So, he's leading the QA efforts from OXO standpoint in terms of the overall QA. So, he will be walking you through all the results, but also be sharing with you the gold layer test suite as well, since they started testing the gold layer as well. And they will also be testing the reports that we've finalized, which will be in scope for our QA.

**Speaker 5** · 00:29:38

Yeah.

**Speaker 2** · 00:29:39

But I have a conflict with another call, with case management. So, I'll be dropping off now, Tommy. So, I hope that. Sure.

**Speaker 6** · 00:29:45

Yeah.

**Speaker 2** · 00:29:46

And then, at the end of the call, if you're aligned, maybe then Kavsheik can send out an email saying that on what's discussed and then you can sign off.

**Speaker 5** · 00:29:55

Sure. Okay. Yeah.

**Speaker 2** · 00:29:56

Thank you so much. Thank you, Kaushik.

**Speaker 5** · 00:29:58

No problem. Thank you, Rashmi.

**Me** · 00:30:01

Hi, Tommy.

**Speaker 5** · 00:30:01

Hello.

**Me** · 00:30:02

Thanks for making time. Yeah.

**Speaker 5** · 00:30:04

No problem.

**Me** · 00:30:04

Yeah. Please go ahead.

**Speaker 5** · 00:30:08

No, no, no. I saw the, I kind of, I saw the XR sheet, the report that you sent through the email. So, you want to walk me through the testing?

**Me** · 00:30:18

Sure. Yeah. Yeah. Sure. Basically, we just wanted to walk you through where we stand on testing for bronze and silver. We just wanted to give you a full picture of what was checked, what we found and where things are today. So, yeah, let me just pull up the status page.

**Speaker 5** · 00:30:41

Yeah. Feel free to share your screen.

**Me** · 00:30:44

Is my screen visible?

**Speaker 5** · 00:30:48

Ah, yes.

**Me** · 00:30:48

Okay. So, this is basically the summary view. So, we have bronze on the left and silver on the right. And there are 45 tables in bronze. And every single one has been tested. 44 of them have passed all of our checks, which I will get into a little later. The details of which I'll get into a little later. So, that is around 98%. Silver is a total of 121 tables and everyone, every single one has been tested. 120 of them are passing. And one of them, we are seeing a defect that is open. So, just a quick bit of history on why these two numbers are different sizes in case it might

**Speaker 6** · 00:31:30

Okay.

**Me** · 00:31:36

come up. So, back in R1 and R2, when we were pulling data in from JDE and other source systems, our production tool just made it easy to just grab every single table available from these source systems in one go. And not just the ones that we had strictly needed at that point in time. So, basically we ended up testing a lot more bronze tables than the earlier releases actually required. And a lot of that was already sitting in production. And this we had aligned with Hydion as well. So, that is why bronze has dropped to 45 and silver has 121 tables. Yeah. So, this table here that you see is the total number of defects in each layer. So, we can see that in bronze there were 13 defects that were raised by our own QA team. And in silver there were 11 defects that were raised. Out of the 13 in bronze, 12 of them have been closed and one is open.

**Speaker 5** · 00:32:44

So, for bronze, when you validate the, what did you guys test in bronze?

**Me** · 00:32:51

Yeah. So, let me just go to this page which has the bronze test details as well. So, in bronze we ran four checks per table. So, the first one is row count where we just make sure that every record that exists in the source actually made its way to bronze. The third one is column completeness. Just checking whether nothing got dropped, renamed or added without us knowing about it. So, here we also do the third check which is column level data checks. So, we check for any null, we basically check for the total number of null values that exist in each column. The length of the maximum and minimum lengths of all of the data that is present in a particular column and also the aggregate totals for that particular column across both the bronze and the source layer. So, this makes us ensure that the data that has been transferred over to bronze from the source is.

**Speaker 5** · 00:33:58

Sorry. Did you check the data accuracy against the source?

**Me** · 00:34:05

Yes. So, that is the row integrity part. So, the row count and the column checks, these are essentially gates. These are checks that do not require a lot of compute or a lot of effort.

**Speaker 5** · 00:34:12

Where is your source?

**Me** · 00:34:16

Once these pass, we also do a row by row check where we essentially calculate like a fingerprint for a particular row. And this we do for all of the rows that exist in the bronze layer for a particular table. And we then compute this unique fingerprint across both the bronze and the source data. So, this ensures that the data that we have in bronze is exactly the same as whatever we have in the source system. So, the source is... Basically, we are comparing directly against the production layers.

**Speaker 5** · 00:34:55

Production layer, production layer from where?

**Speaker 6** · 00:35:00

So, from the source systems like TMS, Ceridian, and all that, Tommy. We are getting the SFTP files and we are comparing the data against these files.

**Speaker 5** · 00:35:14

Can you show it to me?

**Speaker 6** · 00:35:17

Yeah. Rashmi, can you just go where the...

**Speaker 5** · 00:35:26

Do you get any mask data?

**Me** · 00:35:26

For you to review in this folder as well. I'll share the link of this to you over email. But we can just maybe go over one example file.

**Speaker 5** · 00:35:50

Because those... Is there any PRI information will be masked or installed?

**Speaker 6** · 00:35:58

No. No. No. In these sources, we don't have. In fact, for the time and labor, since it also contains, you know, the employee details, as you can just see, we had checked with the HR team as well, Monica, who was part of that people analytics project. And she confirmed that the first name, last name, ID, this is fine.

**Me** · 00:36:19

So, the data.

**Speaker 1** · 00:36:20

It is good to be there.

**Speaker 6** · 00:36:22

There's no issues with that.

**Me** · 00:36:23

That's right.

**Speaker 5** · 00:36:24

Okay. So, this is the raw data. Is that right? The in?

**Speaker 6** · 00:36:33

That's right. That's right. So, this is a raw source. So, from the source system, it gets... Yeah. From the source system, they are dropping the files into the SFTP location. From the SFTP location, FITRAN picks up the files and it is ingesting into the Bronx here.

**Speaker 5** · 00:36:47

Then, can you show me how you test it? I mean, this is the raw data in Excel sheet. What do you guys do to verify the accuracy?

**Me** · 00:36:56

So, there is an automated, yeah.

**Speaker 6** · 00:37:00

So... Sorry, go ahead, French.

**Me** · 00:37:01

Yeah. So, there is an automated script that we run, Tommy, across all tables, and this essentially checks whether the data is matching across both the source and the bronze layers. So, as I had said earlier, we essentially calculate, we do a row-by-row check where for a particular row, we calculate a fingerprint, which essentially is a unique representation of that particular row, of all the data that is present in that row, which is then compared against

**Speaker 5** · 00:37:30

Fingerprint meaning the hash value or something else? So, each row has its own unique hash value. And then, the script compared the hash value of each row. Make sure every row is matched from source to target.

**Me** · 00:37:52

So, what we actually do is we concatenate all the hash values for all the rows, sort them according to numerical and alphabetical order, and then compare this concatenated chunk of hash values against both the bronze and the source. So, if there are any discrepancies, this will be highlighted clearly in the chat.

**Speaker 5** · 00:38:15

I see. So, is there any way you can show me the script? How it's run?

**Me** · 00:38:21

I don't have access to that environment, but we can set up a session sometime later with one of the developers, Tommy.

**Speaker 5** · 00:38:28

Wait. Do you run the test or the developer ran the test?

**Speaker 6** · 00:38:37

No. So, the QE engineer who is there, Supriyo, he runs the test.

**Speaker 5** · 00:38:42

Okay. I would like to see the scripts.

**Me** · 00:38:47

Yeah, sure.

**Speaker 5** · 00:38:48

Okay.

**Speaker 6** · 00:38:51

We will set up a session to walk through the script execution.

**Speaker 5** · 00:38:57

Yeah. And also, another question. Once the data is landed to Bronx, right? And the every... I don't know what's the frequency. They, you know, they loaded the gain, right? Maybe once a day or I'm not sure the frequency. How do we check the interval data?

**Speaker 6** · 00:39:25

So, the data is coming in every day, right?

**Speaker 5** · 00:39:29

Right. So, the data coming next day may contain some changes, right? Correct. Correct. So, do we run the test again to verify the changes also match?

**Speaker 6** · 00:39:44

Yes. So, in this case, for the Bronx testing as well, if I'm not wrong, the team had run for... I think the team had run three or four times each of these tests. And each... And obviously, whenever defects were fixed or anything, the team had to rerun for those as well. But I think it was run for three or four times, if I'm not wrong. I can get that.

**Speaker 5** · 00:40:11

Right. And that's the second thing. And the third, the data in this Excel sheet is from FITRAN or is it directly from the source, the raw source?

**Speaker 6** · 00:40:24

It's from this S3 folder where SFTP is dropping it. I mean, FITRAN is picking it up and it's dropping it in the S3 location. So, we have to get it up from the S3 location.

**Speaker 5** · 00:40:39

So, this is the data before FITRAN pick it up or after?

**Speaker 6** · 00:40:46

This is the... Exactly. Exactly. This is the file that we're getting from the source, right?

**Me** · 00:40:50

I don't know.

**Speaker 5** · 00:40:50

No, no, no. Like, this is the data before FITRAN pick it up or after the FITRAN pick it up.

**Speaker 6** · 00:40:58

So, what happens, Tommy, is that the process that they have, the file gets dropped into an SFTP location. Now, we don't have access to the SFTP location because that's supposed to be a secure location. So, only the tools will have access to that location. So, what FITRAN does is that it picks up the file and then it drops into the S3 location. And then after that, it processes the file and ingests the data into Snowflake.

**Speaker 5** · 00:41:32

So, this file is coming from the source? Correct. Right. So, this is the file that FITRAN pick it up and put it to the bronze. Is that right?

**Speaker 6** · 00:41:49

Correct. This is a file that it picks up to ingest into the bronze layer. Correct.

**Speaker 5** · 00:42:01

Oh, okay. Is there a way to verify or do we need to verify the data before FITRAN pick it up?

**Speaker 6** · 00:42:24

See, FITRAN is just picking up the file, Tommy. So, it is not…

**Speaker 5** · 00:42:29

Right. I understand. Okay. I think we did this type of testing before on the previous phases. Okay. My question to the QA team is always the same. If we tested data after FITRAN pick it up, that means we trust whatever FITRAN give it to us, right? So, we're not validating the entire end-to-end. Because our testing, if we tested the data after FITRAN give it to us, meaning we 100% trust whatever FITRAN give it to us. If FITRAN has the error, we don't know because we only verify the data that FITRAN provides to us to QA, I mean, right? So, if you just, like you told me, the entire end-to-end process, right? So, you know, S3 put it in a secure, you know, the location, then FITRAN goes there to pick it up and process it. Since we don't have access to that secure location, FITRAN goes there periodically, pick up the file, and put it in here. Then we get that raw data, and then FITRAN put that raw data into Snowflake Grounds. Is that right? Got it. So, we are only validating the data that FITRAN pick it up, right? I'm not saying the testing is wrong, okay? I'm just saying we need to tell the business people or even Heidi, okay, this is what we're testing. We're not testing against the real, real source. We're only testing the data that FITRAN pick it up, meaning our testing scope starts from FITRAN, not beyond FITRAN.

**Speaker 6** · 00:44:46

Yeah, the reason for that is also, Tommy, that this is the existing process that they have to be in production.

**Speaker 5** · 00:44:53

I know. I need Heidi and business, maybe Shaz, to sign up on that, right? Because we need, first, we need to define our testing scope. So, the scope, based on what I see, is the scope starts from FITRAN, not beyond FITRAN, right? So, that's one side. The other side is, the other scope, the end scope is the micro-stretch report, right? This is our testing scope. Is that right? Yeah. Right. So, I need people, maybe Heidi or Shaz, to sign up on that. This is our testing scope, because originally, I think our testing scope should be beyond FITRAN. You know, we're validating against the real, real source. Okay.

**Speaker 6** · 00:45:52

Let me discuss that with Arvind and Heidi as well. Correct.

**Speaker 5** · 00:45:57

So, if I'm okay with this approach, but this testing scope, I just need them to say, yes, this is okay. Sure. Because, to me, if FITRAN pick up the file, and then we get the raw data from there, and then FITRAN put it in the Bronx, I personally don't think there's no much differences, right? Because I pick up the, for example, I'm the FITRAN, I pick up the file, I give you a copy, and I put it into the same copy I put it in the Bronx. Because there's no, I don't think that we can find a problem there, right? Because it's the same set of data.

**Speaker 6** · 00:46:56

Got it. I will discuss this with Heidi, Arvind, and then I will have that communication center.

**Speaker 5** · 00:47:05

Right. I just need, I think in the previous release, we had the same conversation. Okay. I told them, if that's the case, I need them to sign up on that our testing scope starts from FITRAN. And I think in the previous release, they say, no, no, no, our testing scope should start beyond FITRAN. That was the conversation that happened a long time ago. Okay. So, that's why the previous QA team actually did the testing against the data, with the data in Bronx against the real data in the source, not the data in FITRAN.

**Speaker 6** · 00:47:42

Yeah. If we have a system from which we are directly picking up, Tommy, in this, say, for example, if it's a success factors or a JD, we have the capability to then connect to the database and validate that. But in this instance, since all we are getting is a file alone, and which is the existing process as well, we are treating that as a starting point. But to your point, I will just check with Heidi and Dervin and send that communication out. Sure.

**Speaker 5** · 00:48:17

Sure. Okay. Thank you. Sorry. Go ahead.

**Me** · 00:48:29

Yes. So, that is the list of the tests for bronze layer, Tommy. For silver, it is just two checks. We do a row count check and a column count check on the business columns. Silver is really just a renamed relabel view sitting on top of bronze with some ordered columns added. So, there's no data transformation happening at that step. So, row and column checks are more than enough to catch anything that could go wrong there.

**Speaker 6** · 00:48:50

So, what's the difference between Bronx and Silver?

**Me** · 00:48:54

So, even here, you can see the past cave. Yeah. Bronze and silver is basically we are renaming the columns to more business-friendly names, to more readable names,

**Speaker 5** · 00:49:06

So, the row counts in server, what row counts we test against you, against the row count in Bronx?

**Me** · 00:49:09

and just building views on top of the bronze layer. Yes. Yeah. So, we check the silver layer tables against the bronze tables, the corresponding bronze tables.

**Speaker 5** · 00:49:30

And the audit column, what is the data in the audit column?

**Me** · 00:49:33

So, the audit columns are basically columns that are added because of the data being picked up by Fibetran and also some transformations being done.

**Speaker 5** · 00:49:41

Right. What is the data inside the audit column?

**Me** · 00:49:43

Yeah.

**Speaker 6** · 00:49:47

It is the load timing. What is the source record load time? What is the load time of that particular, what do you say, particular silver table that we had created? It is basically information around that. There are six audit columns that are created. Let me just read out the names for a moment and I open that.

**Speaker 5** · 00:50:11

And so, in the server layer, the only changes in the server layer is the column names. So, they rename the columns according to the business requirements. Yeah.

**Speaker 6** · 00:50:32

Yeah. So, what we do, Tommy, is that we add these audit columns, right? And for the existing source columns, we provided a functional name. For example, there might be a technical name like IXYGQ or something like that. We provided a more functional name like item underscore code or something like that, right? We also added a description as to what that column stands for. And similarly, at table level, we changed the technical name, something like F411 or something like that to sales order details, right? We provide a functional name and we also provide a description of what that table stands for. And from an audit perspective, we add the data source ID. We add which model, DBT model, is creating that particular table. We add the source record timestamp. We also capture the timestamp of when that particular record has been loaded into our environment. And the other audit things are more from a tracking perspective, like which user has loaded this data. In some cases, it's a system user or a particular developer. If he is loading that table, that load username is also captured. So, there are these five, six audit columns that we capture. I see. But overall, it's a thin layer where we are kind of turning technical thing into a functional description. And it's a pure one-to-one mapping with bronze layer. I see.

**Speaker 5** · 00:52:14

So, can you show me what is the bug that you open in both bronze and silver?

**Me** · 00:52:21

Yeah, sure. So this is the list of defects that are currently open. You will see the same list in the defect tracker Excel sheet as well, which is in the same folder that I shared earlier.

**Speaker 6** · 00:52:37

You can just show all the defects so that only gets a complete view.

**Me** · 00:52:39

Yeah.

**Speaker 6** · 00:52:44

So, the defect register link had that, or you can show it here also.

**Me** · 00:52:48

Yeah. So Tommy, we've been adding all the defects that we've been recording into this sheet and the defect tracker sheet, along with the details of the defect, the assignee, the basically the developer or the queue engineer who's working on this.

**Speaker 5** · 00:53:00

Column can't.

**Me** · 00:53:05

And we've been adding remarks as and when the defect has been closed or fixed and been changing the status here.

**Speaker 5** · 00:53:16

Okay. Hold on. Can you scroll to the top? Yeah. Can you tell me more about the defects number seven? I train column name collision, source column.

**Me** · 00:53:51

Yeah. Yeah. Basically the source data file has two columns with the names PV underscore BG hash and PV underscore BG dollar. And what Fibetran is doing is it's just dropping these special characters that are occurring at the end of these names and replacing them with underscores. So that is more of a Fibetran issue. And we have identified the fix. It says that we are also assessing alternative options because the fix that we've identified is, I mean, there might be a performance degradation because of that. So we're just looking at alternative fixes as well. So I hope that's clear, Tommy. Do you have any...

**Speaker 5** · 00:54:43

So, the five train need to convert the pound and dollar into underscores?

**Speaker 6** · 00:54:54

Yeah. So, what happens, Tommy, the way five train works is that you have to create a connector to a source system to pull the data in. So, this particular connector, when we had created, there's a default setting where some of these special characters are replaced. So, when this connector was created earlier, this was enabled. So, when these columns are coming through, because generally in columns, you don't have special characters, but in this case for the source, we had that. So, this was a rare occurrence that we saw in this particular instance till now. So, when it came through, it kind of got normalized, right? To remove all the special characters. Now, that is a setting at a connector level. So, now if I cannot, since it's an active connector now, essentially, I cannot change it, okay, on the fly. So, the only solution is I have to create a net new connector to bring this one column in, okay? So, that is kind of an overkill, meaning we will have to perhaps eventually end up doing that, but we are also looking at, we are discussing with Arvind, and we are trying to see if there are any other options or paths that we can take. Because it's just one column, and what we have seen till now, it has not been utilized anywhere in the downstream tables or the reports. But we might end up creating another connector just for this one table, because that's the only solution we see as of now.

**Speaker 5** · 00:56:39

Okay, for the issues that's been marked as status fixed, have we retested?

**Me** · 00:56:45

Yes. Yes. Or whatever status has been updated.

**Speaker 5** · 00:56:49

What's the difference between fixed and closed?

**Me** · 00:56:51

Oh, no. It's the same.

**Speaker 6** · 00:56:56

I think it has not been updated once it was fixed. Yeah, after the rerun, it has not been updated.

**Speaker 5** · 00:57:04

And I'm curious about number eight. This is a silver level, right?

**Me** · 00:57:10

Yeah.

**Speaker 5** · 00:57:10

I'm just curious about this one.

**Me** · 00:57:12

So there is a row count mismatch. But basically, I think the mismatch is 24 now. It's not 38. This needs to be updated. But this is because there was a gap in the row count because the tables were not in sync. And once we checked the updated data across both layers and we found that they were in sync.

**Speaker 5** · 00:57:48

According to what you said earlier, the difference between bronze and silver is they just rename the column name, and the rest of the data should be the same. Why there will be a row mismatch?

**Me** · 00:58:04

No.

**Speaker 5** · 00:58:05

So if the firetrain takes the new data every single day, like maybe, for example, I don't know what time, assuming 2 a.m. in the morning every single day, take the new data from source and put it to the bronze, assuming that's the case, then how frequently the bronze populate the new data to silver and then to gold right away?

**Me** · 00:58:05

So there is a timing difference between the data being updated across both layers, Tommy. So if there is new data that is being ingested into the bronze layer, it has to also be reflected in the silver layer, right? So there is a brief period of time difference between the bronze layer being updated and the silver layer being updated. So that is where there's a difference. So it happens at regular intervals.

**Speaker 6** · 00:58:58

Yeah, so the firetrain ingestion is one piece, Tommy.

**Me** · 00:58:59

Yeah, Ravi, go ahead.

**Speaker 6** · 00:59:06

So it runs at a specified time where your bronze table is getting updated. Now the silver, the compatibility view, these are all getting created through dbt jobs. So in production, what happens is that it is all back-to-back, okay, all are triggered in sequence. Since we are in QA, what happens is that once we have all these files and, you know, we refresh the bronze using firetrain, then we might be carrying out some testing. And then we, you know, trigger the dbt jobs, there can be a time lag in between, which causes some of these differences that we see. So then next events, once we identify the root cause, we have to ensure that, you know, we identify when that refresh is happening and we take care of that and we carry out the test viewing that window itself to ensure that everything is in sync. So that is why in the lower environment, since it is not scheduled and sequenced one, you know, right after one after the other, sometimes you see these timing differences.

**Speaker 5** · 01:00:15

Okay, so you're saying this 24 mismatch is based on the day gap.

**Speaker 6** · 01:00:38

It's 24. Yeah. So, yeah, yeah. So for example, Tommy, if say, for example, I have run the dbt jobs today morning, okay, and I am testing all these tables. By the time I am running the test for this particular table, okay, the firetrain sync for the next day has already happened. Okay, but the dbt jobs have not been rerun. So now firetrain bronze, or rather the bronze layer has updated data, while my silver is still showing yesterday's data. So that is the difference that for proxy.

**Speaker 5** · 01:01:22

I see.

**Speaker 6** · 01:01:23

So if I now rerun my dbt jobs, it should work fine. And sometimes what happens is that since these file drops and everything else scheduled, you know, the testing team is not sometimes aware that sometimes these files have come in. And once we get the defect, we realize, okay, this is how it is scheduled, and we have to take care of that piece as well. So then we accordingly change and schedule the testing accordingly so that the dbt jobs are run after the firetrain injection is completed, and the data are in sync when we rerun it.

**Speaker 5** · 01:02:04

Okay, can you scroll more to the left? I want to see the dbt details. So the dbt 11 and 12 and 13, they're all about row count mismatch. They're all caused by this synchronization issue.

**Me** · 01:02:45

So that was a, that was not a synchronization issue. That was a different issue.

**Speaker 5** · 01:02:56

So why we close all this, observe to be derived columns, just close in this. What does that mean?

**Me** · 01:03:04

So these are essentially columns that are, so in the silver layer, we might have a few extra columns that for the data of which is derived from existing columns data in bronze.

**Speaker 5** · 01:03:12

Let me see, bronze 25, column count mismatch, column count mismatch.

**Me** · 01:03:18

So that is expected. So that is expected. And these were manually looked into by the developers and signed off.

**Speaker 5** · 01:03:46

So what is the extra column in there? I mean, for number 14, right?

**Me** · 01:04:07

Yeah. So we have the details on this, Tommy. Maybe we can just add these to the remarks. Right now we've added that these are derived columns, but if you want to examine.

**Speaker 5** · 01:04:14

Okay, can you scroll to the left? So number 14, say column count mismatch. Between bronze and silver, bronze has 119 columns, and silver 120. And same for the previous one, the 13, issue 13. Bronze has 144 columns, and silver has 148 columns. What are those columns, the differences columns? It only shows the number mismatch. What are the actual columns, extra columns in silver?

**Speaker 6** · 01:04:57

So if I'm not wrong, Tommy, and I can get this confirmed with the deal, but there are few tables in DB2 today, where once they are pulling in the data, they are creating new columns as they create the bronze table, which are derived from the existing columns that are being pulled in. In our architecture, we are not changing the bronze, because bronze is a true reflection of the source of the truth. So we are not changing that. We are adding those columns only in the silver layer. So bronze should be a replica of what has been coming in from the source system, while silver kind of aligns with what the next layers, that is the gold and the compatibility, what they would need for their processing. Since DB2 does not have the concept of the three layers, bronze, silver, and gold, it just has bronze and the EDW.

**Speaker 5** · 01:05:55

I understand. My question is, okay.

**Speaker 6** · 01:05:56

So that's where there is a difference between these two columns.

**Speaker 5** · 01:06:01

Okay. My question is very simple. For issue number 13 and 14, can you list the actual names of the columns that are different?

**Me** · 01:06:11

Yes.

**Speaker 6** · 01:06:14

Yeah. Kaushik, can you go to that execution tracker?

**Speaker 5** · 01:06:19

And why this is not the issue anymore?

**Speaker 6** · 01:06:24

Because this is the expected behavior coming. This is how the silver layer itself was written, because we don't want to add the derived columns in the bronze layer. So we are maintaining that in the silver layer itself.

**Speaker 5** · 01:06:40

But according to what you guys told me, the only difference between silver and bronze is the column names are renamed and added columns, right? The added column, they contain six additional added columns in silver. So that's the only difference between silver and bronze. But why would we have some...

**Speaker 6** · 01:07:07

Because there are certain instances, Tommy, and this is not across the board. There are certain instances where DB2 has these type of transformations built into their staging layer itself. So we have to accommodate those changes in our silver layer.

**Speaker 5** · 01:07:30

DB2. What DB2? Because you get the data from Fytrend. That's nothing to do with DB2, right?

**Speaker 6** · 01:07:39

Correct. But in the transformation that they have in DB2 today, they are creating additional columns before the gold and the compatibility layers are created. So that's why we are also... And that is there in the stage layer. Okay. Their stage layer. So now when we are building our mapping and everything, we have to also create those derived columns. So we are not, in our case, creating that in the bronze layer. We are creating that in the silver layer because we want to keep bronze true to the source systems from where the data is coming in.

**Speaker 5** · 01:08:16

So are you saying our server, the data in silver layer needs to mirror the DB2 silver layer?

**Speaker 6** · 01:08:28

For the, in some instances, in terms of the columns and everything. Not the data per se, but the columns and everything, they need to be available. Let me just try to find, can you just show me what is the table name, Kaushik?

**Me** · 01:08:43

It's, uh, lgcy underscore otf post.

**Speaker 6** · 01:08:48

Can you just ping here once? I will just take it quickly and I'll share the details.

**Me** · 01:08:52

Yeah. Should do this.

**Speaker 5** · 01:08:58

Okay. In this sheet, can I, can I, can you add a new column? I mean, who is the tester? I mean, who report this issue, right? Can you add a column as a reporter? Because assignee is the developer, right?

**Me** · 01:09:24

But now who would report this?

**Speaker 5** · 01:09:24

Who report this?

**Me** · 01:09:25

Sure.

**Speaker 5** · 01:09:25

So, so the reporter who report the issue should be, should be also the same person, retest and close it, right?

**Me** · 01:09:27

Yeah. Yes.

**Speaker 5** · 01:09:47

So now we're done with the bronze and silver testing, is that right?

**Me** · 01:10:09

Yes. Barring the one open defect across both layers.

**Speaker 5** · 01:10:16

And, and what's the next?

**Me** · 01:10:21

Yeah. So we've tested both layers fully and, uh, we are now, we're now moving into gold layer testing where we are comparing our final snowflake tables directly against DB2 to ensure that what is being, uh, fair into the reports is accurate and matches exactly. We've shared the test suite with you and we've also run the checks on a few sample tables for which we've also added the results in this folder.

**Speaker 5** · 01:10:55

So for the, we, we have a DB2 report to compare with, is that right?

**Speaker 6** · 01:11:05

That's right. For the report testing, we will have both DB2 report and snowflake report side-by-side, which will be compared.

**Speaker 5** · 01:11:13

Okay. And in snowflake, so we only have three layers, is that right? Bronze, silver, and gold, and then reports?

**Speaker 6** · 01:11:27

Correct. Bronze, silver, gold, and then the reporting layer, which is, which is a mirror of the DB2 layer.

**Speaker 5** · 01:11:35

And the, we should have exact same number of reports in, in, in, in snowflake report, versus the DB2, the report in DB2.

**Speaker 6** · 01:11:52

Correct. So we, the business has identified the reports that they want to test, and we will be testing those reports in both DB2 and snowflake.

**Speaker 5** · 01:12:04

Okay. Do we have a list of reports that are going to be generated in snowflake?

**Speaker 6** · 01:12:13

Yes. Yes. It is there in the, uh, project level tracker, uh, uh, which Lakshmi is maintaining. Um, yeah, just share the link here in the chat.

**Speaker 5** · 01:12:25

And what is the next milestone?

**Speaker 6** · 01:12:44

Uh, the next milestone is to finish the, uh, report testing and, you know, validate all this between DB2 and snowflake, uh, by the week of 21st in two weeks time.

**Speaker 5** · 01:12:58

Oh, 21st, that's less than two weeks.

**Speaker 6** · 01:13:01

Yeah. And by the week of 21st. So maybe by around 21st or 23rd, we'll be wrapping it up. So after that, we'll be having another review with you.

**Speaker 5** · 01:13:12

Okay. Okay. Uh, please. I don't, please schedule the call with me before that. Okay. I, I don't want you to guys to show me everything at the very last day. Okay. I mean, sorry. I think you scheduled a call with me maybe last week. I couldn't make it, uh, my apology, but please, I want to see the, uh, the progress of the actual report side by side and the, to the testing. Okay. Okay. Let's try to avoid doing this on the last day. Sure. Sure. We'll do that. Um, so how, how many report total do we know?

**Speaker 6** · 01:14:01

So the scope is for 50 reports, uh, Tommy, uh, reports. Okay. Yes. Yes. Uh, the business has added few more reports, which are there in their personal folders, which we cannot test because, you know, those are, we don't have access to their personal folders and everything. So right now there are around 60 reports that they have identified. But, uh, for, uh, some of those, as I mentioned, like they, they'll be remote. So we'll be down to around 50 reports.

**Speaker 5** · 01:14:33

I think some are like a certified reports, right? Some are the personal reports.

**Speaker 6** · 01:14:42

No, no. So, uh, it's the 50 is a mix of both certified and department managed reports, because what we found out in the last go live, uh, Tommy was that majority of the reports at the business were using our, uh, you know, department managed reports. They were not certified reports. Uh, so this time around, that's why there was an earlier, early, uh, you know, intervention with business to identify what are the critical reports for them. Um, so the 50 that I'm talking about is a mix of IT certified, IT submanaged and the department managed. Do we have access to those reports? Uh, yes. Yes. So department managed, we have access. So there, there are three layers of reports in micro strategy domain. One is the IT managed, which is in the IT folders. Then there's a department managed, which is in each domain's folders, which also we can access. Uh, but the third type is a personal folder, which is like, you know, uh, if say, for example, you are a micro strategy user, you will generate their own report. Right. Exactly. Exactly. And that is not accessible to anyone. And honestly, that is not something we want to certify or test as well, because you can do maintain change every day. Right. We cannot control that. Right. We cannot control that. So, um, that's where, you know, we will be testing around 50 IT and department managed reports, a mix of IT and department managed reports.

**Speaker 5** · 01:16:12

For the personal report, can we do, um, for example, we have access to their DB2 reports, right? We can generate our own personal report, right?

**Speaker 6** · 01:16:26

We can generate our, we can potentially do that if it is really critical, but what, uh, what the team had asked them to do, like Lakshmi and Arvind had asked them to do is identify what are the P ones for them, um, which we will be testing. And some of these personal reports, which are like very specific to one user, they can be testing that as part of the UAD. And if they face any issues, we can help them resolve that, but mostly they will be testing.

**Speaker 5** · 01:16:56

No, I mean the, okay. Like you said, three categories of the reports. Certified report, we definitely can, can, can, can test it, right? Because the certified IT maintain, that's a fixed, all the value of filter are all fixed and we can verify. And department report, we can mimic the department report, right? Their department, we can look at their, their, their, their filter, the, the, the settings configuration, then we could maybe that department report in the, in the snowflake microstrategy.

**Speaker 6** · 01:17:27

Right. Correct. So department manage is in scope. We are testing the department.

**Speaker 5** · 01:17:36

Yeah. The, the, the concern is the, the personal report, right? So we don't know what they're doing, right? It's totally out of our control. Every individual can generate their own reports for their own purpose. So since we have access to the DB2 reports, we can generate some random reports using the filter and the criterias. Then use the same filter and criteria in Snowflake reports, then the reports should match, right?

**Speaker 6** · 01:18:17

Yeah, but the personal reports, we don't have access to their query, their filter, nothing.

**Speaker 5** · 01:18:24

No, no, no. Even in DB2. I'm not saying we need to access their query. I'm just saying if I have a privilege, I can access the DB2 reports, I can generate my own personal report.

**Speaker 6** · 01:18:44

Yeah, meaning if I have access to that DB2 report, I can generate, yes. Sorry, I did not get the context there.

**Speaker 5** · 01:18:53

Right. So since you said we can access to the DB2 reports, all the DB2 reports, that means there's no permission issue. I mean, since it's a non-pron, we can generate our own personal report in DB2. Then use the same criteria in Snowflake and generate the same personal report, then the data should match. Is that right?

**Speaker 6** · 01:19:19

No, so in DB2 as well, Tommy, these reports, I cannot access. The personal folder reports, I cannot access.

**Speaker 5** · 01:19:26

No, I'm saying when we can create our own personal report.

**Speaker 6** · 01:19:31

We can create, but I can create a random report, right? I don't know if that is a report they have or not. So I can create one too. Yeah, I can create reports.

**Speaker 5** · 01:19:40

That is not a problem. What I'm saying is the only purpose of doing the report validation is to make sure the data are valid, right? So I can go to DB2, I can create my own personal report, and then I can go to the Snowflake using the same filter and create the same personal report that I created in DB2. So then the report should match, right? I'm just saying it could be the smoke check for us. Make sure that data are matched. The random data we generate on both sides are actually matched.

**Speaker 6** · 01:20:25

Yeah, yeah. That is being done for all the reports in scope. And even for, you know, as we mentioned, for some, we will just be taking some of the tables and we'll be validating that. In fact, we will also, it's not just the reports, we'll be also carrying out tests for each table against the DB2 table. So even outside of reports, we'll be comparing the tables with the DB2 tables.

**Speaker 5** · 01:20:51

Okay. If that's doable, I'm just saying if, is that doable, right?

**Speaker 6** · 01:20:57

Yeah, it's doable. It's doable.

**Speaker 5** · 01:20:59

Okay, so what's your plan for doing those three layers of testing, three, you know, categories of report testing? First, we, you know, since there are lots of reports, 50 or 60 reports total, when the development can be done or is it done?

**Speaker 6** · 01:21:25

Development is done. We are in the process of report repointing and then we have to, you know, start on the testing.

**Speaker 5** · 01:21:32

Okay, so meaning we can start validating report tomorrow or Friday, right?

**Speaker 6** · 01:21:40

No, we have few reports where we can start the work. The few other reports, we have to do some data setup in the QA environment, like we have to get some production history data and everything loaded so that it can be in sync with the DB2 prod. So the activities around that is in progress. So, but for some of the reports, it is already there. Repointing is also completed 100%. So some of those we can get started, which we are planning to start this week.

**Speaker 5** · 01:22:12

Okay. I think I need the multiple car with you guys to validate all the reports. There's no way I can see all 50 or 60 reports in one single car. Can we, for example, once you've done 10 reports, can you guys show it to me, right? And another 10, another 10, another 10.

**Speaker 6** · 01:22:35

Okay. Sure. We can plan something like that.

**Speaker 5** · 01:22:40

Would that work?

**Speaker 6** · 01:22:41

Yep.

**Speaker 5** · 01:22:42

So we can have like a checklist, right? This is off the list, off the list. Okay. Yeah. Right. Okay. Yeah. That's all. But I still need the, I need the, you know, like we talked earlier, right?

**Me** · 01:23:08

That's his scope.

**Speaker 5** · 01:23:08

The testing scope. I need either Heidi or Jess from business, BRM, to be okay that our testing scope start from

**Me** · 01:23:18

You know, thank you.

**Speaker 5** · 01:23:19

the FITRAIN, right?

**Me** · 01:23:19

I will, thank you for your opportunity. Thank you.

**Speaker 6** · 01:23:22

Sure. Sure. I will talk to Arvind and Heidi about it.

**Me** · 01:23:27

We will, thank you for sharing the information.

**Speaker 5** · 01:23:28

Okay. All right. Yeah. All right. Thank you. Thank you. Thank you, guys.

