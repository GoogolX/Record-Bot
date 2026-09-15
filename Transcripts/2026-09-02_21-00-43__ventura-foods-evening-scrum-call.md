---
title: "Ventura Foods Evening Scrum Call"
recorded: "2026-09-02 21:00:43"
context: "Kaushik, Lakshmi, Ravi, Shashvat, Manjeet, Aravind"
watch_for: "Action items per person"
duration_seconds: 1465
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "K"  # 1 min of speech
  - "Speaker 3": "Lakshmi (high)"  # 10 min of speech
  - "Speaker 2": "Manjeet (high)"  # 6 min of speech
  - "Speaker 6": "Ravi (high)"  # 3 min of speech
  - "Speaker 1": "Arvind (high)"  # 1 min of speech
  - "Speaker 4": "Rajeshwari (high)"  # 1 min of speech
  - "Speaker 5": "Shashvat (high)"  # 34 sec of speech
speaker_evidence:
  - "Speaker 3": "Me (Kaushik) says 'Yeah, sure, Lakshmi' at line 42; Speaker 3 runs meeting and addresses team members by name throughout"
  - "Speaker 2": "addressed as 'Manjit/Manjeet' repeatedly by Speaker 1 and Speaker 3; discusses TMS/TNL work and data modeling"
  - "Speaker 6": "Speaker 2 addresses 'Ravi' at line 202 when asking about VFDW complexity; discusses table/report mapping and data structure confirmation"
  - "Speaker 1": "addresses Manjeet about TNL updates, data model approvals; only unassigned name from context is Arvind, matches data model approval role"
  - "Speaker 4": "talks about report repointing at line 408-410, explicitly identified as Rajeshwari at line 406; not in original context but on call"
  - "Speaker 5": "addressed as 'Shashvat' by Speaker 3 at line 134 when asking for updates on development tables"
status: summarized
---

## Transcript

**Speaker 1** · 00:00:00

Good morning, good morning, good morning, good morning, good morning, one quick thing, the OFR is that branch transfer, it's going this Friday, right?

**Speaker 2** · 00:00:23

Yes, we already have that. I have to confirm with Siddharth if we already have a CAB request open, I'll confirm on that, but yeah, the test is going on, yeah.

**Unattributed** · 00:00:41

Perfect.

**Speaker 3** · 00:00:44

All right, let's get started. So, I hope all these access issues and everything got resolved with this document. So, okay, so do you want to go first, Kaushik?

**Me** · 00:01:03

Yeah, sure, Lakshmi.

**Speaker 3** · 00:01:04

Okay, perfect.

**Me** · 00:01:05

So, if you'll just scroll up a bit, you can see that we've basically completed running the tests for all the tables across both bronze and silver layers.

**Speaker 3** · 00:01:17

Okay, perfect.

**Me** · 00:01:18

Execution is 100% complete, and we've identified a few defects that we've already assigned to our developers, and we're on track to close them by this Friday.

**Speaker 3** · 00:01:30

So, you do have your timeline for Friday, right? So, let me quickly check.

**Me** · 00:01:42

Yeah, so the execution is complete for whichever tables have defects.

**Unattributed** · 00:01:42

Okay. Okay.

**Speaker 3** · 00:01:43

And then the same applies to this one, right?

**Me** · 00:01:47

We've just kept the QA validation status as in progress.

**Speaker 3** · 00:01:56

Yeah, I just want to make sure. Okay.

**Speaker 4** · 00:01:57

So, these are the ones that Atul was able to complete, all the silver new ones. Okay.

**Unattributed** · 00:02:04

Okay.

**Speaker 3** · 00:02:05

So, these are the ones that Atul was able to complete, all the silver new ones. Okay. And then what about gold? Let's go to gold.

**Me** · 00:02:12

Yes, yes, correct.

**Speaker 3** · 00:02:13

You haven't started gold, right? You haven't started gold. So, you haven't started gold, right?

**Me** · 00:02:23

So, gold, we have the test suite ready. We'll share this with Tommy over email, but regarding status, I think Ravi would be able to help you with that.

**Speaker 3** · 00:02:37

You haven't started gold. Okay. All right. Any other blockers, concerns? So, once you're able to complete your silver and bronze test, you can then reply on top

**Me** · 00:02:44

None, as of now, from the QA side of things, for me, not sure. Okay.

**Speaker 3** · 00:02:59

of the earlier email that you sent earlier this week, right, for Tommy's review. If we can get time with Tommy in a call, let's send it in an email and he's aligned with doing an offline review and then we can then hop onto a call and then clarify if there are any more questions.

**Me** · 00:03:17

Sure, Lakshmi, yeah.

**Speaker 3** · 00:03:20

Okay. So, I will still go ahead and let me do one thing. I will send an invite with Tommy for early next week. So, you're comfortable with doing that since you will be closing out the complete bronze and silver, right, by Friday.

**Me** · 00:03:32

Yeah, yeah, sure.

**Speaker 3** · 00:03:36

Okay. All right. So, Shashvat, do you want to go next?

**Speaker 5** · 00:03:49

Yeah, Lakshmi. So, all the tables are in like going according to the plan. We are updating the dates for which we need to update it. And otherwise, currently not as such blocker which we are facing.

**Speaker 4** · 00:04:08

Okay.

**Speaker 3** · 00:04:11

So, right now you have about 40 tables, right, which are either in progress or not started, which are due for completion for development.

**Speaker 5** · 00:04:21

Yeah, so some tables may, so like for PVV we have the new target dates and these are a little bit complex.

**Speaker 3** · 00:04:31

Yeah, I see that.

**Speaker 5** · 00:04:32

And similarly, yeah.

**Speaker 3** · 00:04:38

Okay. And what about these ones?

**Speaker 5** · 00:04:43

So, these we yet, I need to discuss this. Yeah, yeah, Lakshmi.

**Speaker 6** · 00:04:48

So, these are the new tables that got added because of the new reports that were introduced. Okay.

**Speaker 4** · 00:04:54

Okay.

**Speaker 6** · 00:04:55

So, yeah. So, these we will be taking after we finish the existing set of tables. Because primarily what we are noticing is that the complexity is very high when it comes to the finance tables. The TMS, TNL, as I mentioned yesterday, I was just deprioritizing it. So, we just want to finish the first set of finance tables that we have before we pick this up. So, mostly we will pick this up from next week onwards. But this should not be a blocker for us to get started on the QA or unit testing of all the reports. Because these anyway, as we were discussing yesterday as well, right, some of these reports we have to revisit whether these have to be tested or not. But aside that fact, this will be picked up once we finish the other tables. And I have to discuss with Manjeet as to what date we should put here. So, I'll enter these dates. But right now, I don't have a specific date planned for it.

**Speaker 3** · 00:05:55

Okay. So, by when can we get these dates? I know Manjeet.

**Speaker 6** · 00:05:59

Yeah. Manjeet is here. We discussed briefly today morning. But we'll just go through it today. And then we'll finalize. Okay. After the call, we'll just review that until we finalize.

**Speaker 3** · 00:06:12

Okay. All right. So, but you don't anticipate any risks like you said, right? But that's a true statement, which will not impact our overall TV completion. Okay.

**Speaker 6** · 00:06:28

Yeah. Because TNL, we will be finishing next week. And then there are some reports. For example, some tables like adaptive insights fact that you see here. These are not directly linked to any report right now. Okay. So, that's why, again, I was deprioritizing that. Similarly, for PCS, if you see the customer requirement, that is kind of an audit table. It has just one record. Okay. So, it is kind of an audit table. So, we generally do the audit mapping jobs at the end. So, this is, again, not a blocker for any development, meaning any report testing. So, that's why you will see some of these tables just moving around. But these are not showstoppers for the larger testing and all. We intend to start the oil trading, you know, gold layer testing and report testing from tomorrow. There's only one fact table which is pending. So, we intend to finish the remaining tables, meaning we intend to start the testing for that as soon as possible. Similarly, for PCS as well. So, the focus will also be to start the testing for PCS and oil trading from tomorrow.

**Speaker 3** · 00:07:41

Okay. Sounds like a plan. So, now let me also go through the report tracker once. Yes, Manjit, we can hear you.

**Speaker 2** · 00:07:49

Yeah. Yeah, we can. Sorry. So, for VFDW, sorry, I missed for a few minutes. For VFDW, did we raise the concern about the complexity? And then all these additional reports causing the issues, Ravi?

**Speaker 6** · 00:08:07

Yeah, that's what I was mentioning. That what we are seeing is that finance is getting going to be highly complex in VFDWH. Yeah.

**Speaker 2** · 00:08:16

Yeah.

**Speaker 6** · 00:08:16

And that's why there is a delay right now in completing this. So, that's why I have not yet given a date for the new tables that were identified as well.

**Speaker 1** · 00:08:24

Okay.

**Speaker 6** · 00:08:25

For the new reports, right? So, that is one definite item. The second is, Raja, Lakshmi, I think we discussed yesterday as well. Until and unless we don't close on those 50 reports, it's very difficult for us to plan and then get started on the report testing. We are still doing some checks here and there, whichever we have repointed, but I mean, that is something we have to close.

**Speaker 3** · 00:08:49

Yeah, but that's something dependent on you guys to get back with the underlying data structures, right?

**Speaker 6** · 00:08:56

Yeah, I think oil trading, Rajeshwari will send it out today. And similarly, for finance, we will plan it out for either today or tomorrow. By tomorrow, we will try to send it off. Okay.

**Speaker 3** · 00:09:10

All right. We'll get into the reports shortly, Ravi. I just want to make sure that we cover all the other things. So, Manjeet, I know there are certain items still assigned to your name, but I know you are being pulled to other things. So, I just want to call that out. So, is your time getting impacted to complete any of the Release 3 committed deliverables because of you getting pulled into other things?

**Speaker 2** · 00:09:40

So, a little bit, but we're trying to catch up to that, but so some, especially around those TMS, I have to do more, you know, sort of, I would say go through the mappings and then figure it out. Typically, I use Cloud, because I had to travel to Irvine office yesterday. I didn't get an option to use any AI. So, I'll try to catch up for that today. As of now, there is a 20 to 30% impact because of, you know, the other activities that I'm getting pulled into. But we'll try to, you know, wrap it up this week and catch up this TMS stuff.

**Speaker 3** · 00:10:36

Okay. And, yeah, so, yeah, let's please make sure that Release 3 is your top priority right now as we are getting closer and closer to our QA validations. Yeah, and also, on the data modeling part, right, what is going on with that?

**Speaker 2** · 00:10:57

Yeah, so there's nothing on the data modeling part. Technically, it is not pending on the data modeling part. It is more around these tables around TMS that I have to get the corresponding, because these are complex. So, one, we have a template for the existing BI-EDW mappings. So, using that template, we were able to generate the DBT pipelines. But because these are VF-DWH, the template is not working. So, we are now trying to go through the Informatica code and then maybe adjust the template accordingly. So, that is where the work, most of the work is going on, at least from me. So, it's not about data model.

**Speaker 3** · 00:11:45

Okay. Then, then if that, if there isn't anything open on that, then can we close the loop on that data model? So, Arvind, do we think we should be closing that loop? So, that completes the complete analysis and design deliverables that OXO has committed for, right?

**Speaker 1** · 00:12:02

Manjit, you updated the TNL, the employee one as well, right?

**Speaker 2** · 00:12:09

So, for employee one, yeah. So, that is something which I have to pick up after this TMS. Like right now, I'm focusing on that. There are a few career activity A and F tables. So, I finished, I think, A. I have to focus on the F and then I'll share it to the team. Then, there are a few other things that need to come up in the views point of view. And then, I'll come to the TNL. Because I need to work with Andre for certain things. So, I had to work with Andre to get some details. So, I learned that there is one table for Kronos that we get from Kronos. And that's basically stale data. So, Andre was telling me yesterday. So, I have to confirm with him today.

**Speaker 1** · 00:13:02

So, Manjeet, so when you get a chance, just update that table in the model and send it over to me. Okay. So, that we'll wrap it up. I mean, whenever, but otherwise, there is nothing that's stopping here. So, send it to me or I'll approve that.

**Speaker 2** · 00:13:22

Yeah, I think the one approval is probably, yeah, I'll check with you later, Arvind. Probably getting access to that co-pilot. Okay. If that's not, yeah. That will help me there.

**Speaker 3** · 00:13:37

So, when are we planning? So, I know, because Arvind cleared, right? So, Manjeet, now that it's on you to send the email and close the loop on that, okay? And then I can confirm back saying that, hey, this is done.

**Speaker 2** · 00:13:51

Yeah, yeah. That's the plan.

**Speaker 3** · 00:13:53

Okay. If it's just an email, let's do it.

**Speaker 2** · 00:13:56

It's not email, yeah. I had to get all the facts in place.

**Me** · 00:14:01

If you're being pulled into any other things that is impacting release three, I need to know

**Speaker 3** · 00:14:03

Okay. So, is it going to be today?

**Me** · 00:14:06

right away, please.

**Speaker 3** · 00:14:06

Because that's the commitment I got from you guys, right?

**Me** · 00:14:07

because the timelines are getting pushed and pushed and pushed and pushed. We may feel like we have time, but we want to have some time in the end to take care of any unknown issues.

**Speaker 3** · 00:14:10

For today.

**Speaker 2** · 00:14:11

We only have 24 hours, so it's okay.

**Speaker 3** · 00:14:13

Yeah. So, that's where I'm coming from, right? If you're being pulled into any other things that is impacting Release 3, I need to know right away, please. Because the timelines are getting pushed and pushed and pushed. So, we don't want to push these timelines anymore. We may feel like we have time, but we want to have some time in the end to take care of any unknown issues in QA, right? Especially when we're doing report testing.

**Speaker 2** · 00:14:42

Yeah.

**Speaker 3** · 00:14:44

So, Arvind, I'm just calling this out, right? I know Manjeet is a critical resource when it comes to on-site. There is no one other than Manjeet. So, I just want to make sure that Manjeet is not being pulled into any other things other than Release 3 for the next few days, please. Because I was always told he's 100% on Release 3, but I don't think he's 100% any single day.

**Speaker 2** · 00:15:08

I mean, we just have to navigate through that, Lakshmi. That's how we have to cover. But yeah, we'll try to bring everything. Because there are some dependencies around getting these codes. See, the complexity is because of these VF tables. And because it is challenging for other folks, and I probably have to work with Andre to get any details around that. That is what is causing these, I would say, these delays. Once we sort this out, I think we should be good. Because all the build work is being done from offshore. So, we'll catch up this week.

**Speaker 3** · 00:15:48

Perfect. And then, can we get these dates as well, Manjeet, please? For these items.

**Speaker 2** · 00:15:56

Oh, they are assigned to me.

**Speaker 3** · 00:15:58

They are not assigned to anyone? But Ravi mentioned that he's going to talk to you, and then you will be procuring them.

**Speaker 2** · 00:16:04

Yeah, I've given the initial template code for you. I have to look back. Let me work with Ravi on that.

**Speaker 3** · 00:16:15

Yeah. Okay. Sounds good. So, let me ask you this. So, do you anticipate any risks, Manjeet, with all your work?

**Me** · 00:16:22

And with these open things? And with the complexities of VFDWH? It's just around, you know, so many things going on.

**Speaker 3** · 00:16:28

Where you're trying to help other teams as well?

**Me** · 00:16:29

Yeah. I need to know what those priority shifts are.

**Speaker 3** · 00:16:31

And with these open things?

**Me** · 00:16:32

If I'm not going to do it, I need to know right away. If I'm not going to do it, I'm not going to do it.

**Speaker 3** · 00:16:33

And with the complexities of VFDWH?

**Me** · 00:16:34

I'm going to do it. Yeah. I'm going to do it.

**Speaker 2** · 00:16:38

I don't see risk, per se, right now.

**Me** · 00:16:39

I'm going to do it.

**Speaker 2** · 00:16:42

It's just around, you know, with so many things going on.

**Me** · 00:16:43

I'm going to do it.

**Speaker 2** · 00:16:46

There will be a lot of priority shifts that keep happening. Apart from that, I don't see any risk. Yeah.

**Speaker 3** · 00:16:53

I need to know what those priority shifts are. If you're being pulled into, I need to know right away. If I'm not knowing it, then that's a problem, too. Because I will be, in my mind, taking the team's word for real, right? That, hey, you committed for a certain date, so the expectation is it will be complete. But then, on the 10th, we don't want to hear that, hey, we are being pulled into other things, which is why it's getting even more delayed. So we cannot do that anymore.

**Speaker 2** · 00:17:21

Yeah, I get that, Lakshmi. But what we have to understand is we have a platform that we have deployed as part of release one and release two. And bringing stability to that is a critical thing. Okay? So when, as long as we are working, making sure that the platform is stable, then we'll not get into challenges. So that's why temporary priority shift is bound to happen. And that's what we are trying to, we have set up some frameworks. We'll try to cover them this week. I've already handed over certain things to offshore. Hopefully, I don't have to get involved more. But I think, yeah, let's work wait till this week. And from next week, I think everything will be on release three for me.

**Speaker 3** · 00:18:09

Yeah, where I'm coming from is, I don't want us to keep repeating the same things again and again. But where I want to go with this is, if your time is not fully into this, I would definitely take help from Heidi, right? I can go and tell her, hey, the resource, my resource is being pulled into other things. I understand the priorities, the competing priorities. But at the same time, this can't slip, right? So I want to make sure that you're getting the right support. Yeah. Okay. So having said that, since we have some time, let's go through. So Rajeshwari, do you want to go with your updates in terms of report repointing? How come these are? Oh, so you updated this with the 63. Perfect. Yeah, go for it, Rajeshwari.

**Speaker 4** · 00:18:56

Yeah, whatever table was deployed to QA, right? I have repointed them. And yesterday, as we discussed for the table mappings, right? For oil trading, it is done, Lakshmi. And I have updated in the same sheet. You would see table mapping for report. The next one, next time.

**Speaker 3** · 00:19:16

Oh, next. Oh, table. Okay.

**Speaker 4** · 00:19:18

Yeah. You can filter on domain for oil trading. You should be able to find the table's access for each report. Okay.

**Speaker 3** · 00:19:32

Okay. So where are the common tables here? I don't see any.

**Speaker 4** · 00:19:43

I know. Example, if you see the third, I mean, D column, KPI export, report, export, right? It can be used in multiple other reports also.

**Speaker 3** · 00:19:54

Oh, okay.

**Speaker 4** · 00:19:59

Okay.

**Speaker 3** · 00:20:00

Okay. So since you have this, so who is going to meet with Arvind to get this sorted? We have 10 minutes. We can do it either now. I mean, 10 minutes won't be enough for sure. So who is going to meet with Arvind to get this filtered so that we can then go back with the filtered list to Andy. So Manjit, do you think you will have time to do that today with Arvind? Or will Ravi have to do it with Arvind?

**Speaker 2** · 00:20:30

Can it end up in the morning time? I think I mean, next few couple of hours, I'll be occupied. So I think Arvind and I will probably meet. No, can. Okay. One minute.

**Speaker 3** · 00:20:46

So I can scare you with something?

**Speaker 2** · 00:20:48

I'm unsure. Like if Arvind is available, Ravi, can you and Rajeshree close that in the morning?

**Speaker 1** · 00:20:56

Actually, I have back to back. Let's do this in the afternoon, Manjit. You and me will connect.

**Me** · 00:21:03

OK.

**Speaker 2** · 00:21:04

Okay.

**Speaker 1** · 00:21:05

Let's connect around like four. Sure.

**Speaker 3** · 00:21:12

Okay. So I'm not scheduling anything. Probably you guys can ping each other and then meet. Right, Manjit? So that's an action item for Manjit.

**Speaker 2** · 00:21:21

Sorry. So what is the work here? Just finalizing the reports, right?

**Speaker 3** · 00:21:27

Yes.

**Speaker 2** · 00:21:28

Okay.

**Speaker 3** · 00:21:29

So basically, the ask is just to be clear. Since we have a total count of 62 now, and given the timelines, the team is committed or planned only for 50 report testing, there are 12 additional that we need to see if we can reduce the count in order to go back to business. We need to make sure which ones are having the common tables underneath. So that is the exercise that Rajeshwari did and she came up with all these details, right? So now the next step is for you to meet with Aravind to go through these tables and the reports and see which ones can be skipped and they can take it as part of UAT because all the tables would have been tested by us and the other reports will be tested by us. So if we know those report names, then I can go back to Andy and then we can ask him, hey, these are our observations so let us know what you think type of thing. And we are not going to tell them anything like, hey, we're going to reduce accounts. We don't want to tell all that stuff. It's going to confuse them. We're going to just make a conversation saying that, hey, these underlying tables are already tested and taken care by other reports. So we're going to test all these reports, but the other reports, we will help you when you're doing UAT. That's how we want to take the conversation, right, Aravind, based on our alignment yesterday.

**Speaker 1** · 00:22:53

That is correct, yeah. We'll connect on that. Before we connect with the business, we will discuss and then connect with the business. Absolutely.

**Speaker 3** · 00:23:01

Yes, yes. Not before that, yes. So, Manjit, if you can do that exercise with Aravind, because Ravi clearly mentioned that it is a critical step because team is waiting to test the reports, right? So let's close that out and then offshore team will have all these details ready for them to take up the reports. Okay.

**Speaker 4** · 00:23:21

Okay, sounds good. And Lakshmi, one more thing was like, for the priority one, I see the number of reports have increased now. Initially, when we were doing analysis, right, we had around close to 30 reports or something. Now it has increased to 63 reports. Okay.

**Speaker 3** · 00:23:40

I think you're repeating the same thing, right, Rajeshwari? Can Ravi fill in Rajeshwari?

**Speaker 6** · 00:23:50

Yeah, yeah, Rajeshwari, that is the same exercise.

**Speaker 3** · 00:23:52

There is a huge gap in Rajeshwari's understanding.

**Speaker 6** · 00:23:54

That is the same discussion, Rajeshwari, that's what we are sharing and we will reduce the reports. Yeah.

**Speaker 3** · 00:24:01

Yeah. Yeah.

**Me** · 00:24:02

It's done.

**Speaker 3** · 00:24:03

Okay. Any other questions, concerns from the team? Okay. If there aren't any questions, concerns, then I'll give back everyone six minutes. Thank you so much.

**Speaker 1** · 00:24:18

Thank you.

