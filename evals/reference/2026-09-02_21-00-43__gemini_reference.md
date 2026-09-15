---
source: gemini-2.0-flash-reference
recording_id: 2026-09-02_21-00-43
duration_seconds: 1465
channels: stereo (L: call, R: mic)
---

## Transcript

**Lakshmi** · 00:00
Good evening.

**Arvind** · 00:01
Hi, Lakshmi. Good morning.

**Lakshmi** · 00:02
Hi, Arvind.

**Shashwat** · 00:05
Good morning, guys.

**Arvind** · 00:08
Morning.

**Kaushik** · 00:09
Morning.

**Shashwat** · 00:16
Manjeet one... Manjeet one... Is QA translates going this Friday, right?

**Kaushik** · 00:23
Yes, we are already... we already have that. Uh, I have to confirm I have to confirm uh, on the CAB if we already have CAB CAB request open. I'll confirm on that. Yeah, test test is going on, yeah.

**Shashwat** · 00:37
Perfect. Yeah.

**Lakshmi** · 00:44
All right, let's get started. So, okay, so I hope all these access issues and everything got resolved with this document. Um, so, okay, so do you want to go first?

**Kaushik** · 01:05
Yeah, sure, Lakshmi. So, if you'll just uh scroll up a bit, you can see that uh we've basically completed running the tests for all the tables across both bronze and silver layers. Execution is 100% complete, and uh we've identified a few defects that we've already assigned to our developers, and uh we're on track to close them by this Friday.

**Lakshmi** · 01:29
So, you do have So, you do have your um your timeline for timeline for Friday, right? So, let me quickly check.

**Kaushik** · 01:42
Yeah. So, the execution is complete uh for whichever tables have defects. We've just uh kept the QA validation status as in progress.

**Lakshmi** · 01:52
Okay. And then the same applies to the silver ones, right? Yeah, just want to make sure. Okay. So, these are the ones that silver These table come under silver All the silver new ones?

**Kaushik** · 02:13
Yes. Yes, correct.

**Lakshmi** · 02:15
Okay. And then what about what about gold? Let's go to gold. Let's go to gold. You haven't started gold, right? You haven't started gold, right?

**Kaushik** · 02:23
So, gold, we have the test suite ready. Um, we'll share this with Tommy over email, but uh regarding status, I think Ravi would be able to help you with that.

**Lakshmi** · 02:36
Okay. All right. All right. Any other blockers? Any other concerns? Kaushik?

**Kaushik** · 02:44
Uh, none as of now from the QA side of things for me.

**Lakshmi** · 02:50
Okay. Yeah, so the once you're able to complete your your silver and bronze tests, you can then reply on top of the earlier email that you sent earlier this week, right, for Tommy's review. If we can get time with Tommy in a call send an email and he is aligned with doing an offline review and then we can then hop onto a call and then clarify if there are any more questions.

**Kaushik** · 03:17
Sure, Lakshmi. Yeah.

**Lakshmi** · 03:19
Okay. So, I will still go ahead and Let me do one thing. I will send an invite with Tommy for early next week so you're comfortable with So that you'll be closing complete bronze and silver, right, by Friday?

**Kaushik** · 03:33
Yeah. Yeah, sure.

**Lakshmi** · 03:35
Okay. All right. So, All right. So, what So, Shashwat, do you want to go next? So, Shashwat, do you want to go next?

**Shashwat** · 03:48
Yeah, Lakshmi. So, yeah, Lakshmi. So, uh all the tables all the tables are in like according to the plan, going on for updating the dates updating the dates for which we need to update it. Otherwise, currently no as such blockers which we are facing.

**Lakshmi** · 04:08
Okay. Okay. So, right now you have about 14 tables, right, which are either in progress or not started, which are which are due for completion for development?

**Shashwat** · 04:22
Yeah, so some tables like so like for PV, we may have the new target tables. These are a little bit complex. Yeah, similarly. Yeah.

**Lakshmi** · 04:35
Uh, and for these uh Okay. So 14 is... Okay. And what about these ones? And what about these ones?

**Shashwat** · 04:42
So these we Yeah, these we yet need to discuss with Ravi.

**Ravi** · 04:47
Yeah, Lakshmi. So these are the new tables that got added after we new reports that were introduced. So Okay. Yeah, so Yeah, so these we will be taking after the existing set of tables because existing set of tables we are primary what we have complexities that the complexity is very high when it comes to the finance tables. The T&L T&L, as I mentioned yesterday, I was just detailing as well. So we just want to finish the first set of finance tables that we have before we pick up the Mostly, we'll pick this up from next week onwards, but uh this should not be a blocker for us to get started on the QA or testing of all the reports uh because these anyway as I as I mentioned yesterday as well, right, some of these we need to see whether these have to be tested or not. But as such, this will be picked up once we finish the other tables. And I'm just discussing with Manjeet on what date we should put here, so I'll I'll enter these dates. Uh, but right now I don't have a specific date planned for it.

**Lakshmi** · 05:54
Okay. So, by when can we get these dates? Manjeet I know Manjeet... Manjeet...

**Ravi** · 05:58
Yeah, I think Manjeet is here. I think Manjeet is here. I had a discussion briefly with him this morning. We will just go through it today and then finalize. Then we'll finalize.

**Lakshmi** · 06:08
Okay. After the call, we'll just review that and then...

**Ravi** · 06:13
Yeah, I think T&L T&L we'll be finishing next week and then some for example, some tables like adaptive insights fact that you see here, these are not directly linked to any reports as such, so that's why again I have de-prioritized. Similarly for PCS, this is a customer requirement. That is kind of a It has just one report. It's kind of an audit table. So generally do the audit mapping job for T&L. So it's This is again not a blocker for any reporting work, so that's why you will see some of these tables just floating around, but these are not showstoppers for the larger testing and QA. We intend to start the oil trading, gold layer testing and report testing from tomorrow. There's only one fact table which is pending. So we'll finish We intend to finish the remaining tables, and then we intend to start the testing from tomorrow. Similarly for PCS as well. So the focus will also be to start QA testing for PCS and oil trading from tomorrow.

**Lakshmi** · 07:40
Okay. Sounds like a Sounds like a plan. So, now let me also So, now let me also go to report tracker one. Yes, Manjeet, we can hear you.

**Manjeet** · 07:49
Yeah, so for VFW so far I list a few things. Uh, for VFW, did we raise the concern about the complexity on these audit reports, all the issues, uh the issues, Ravi?

**Ravi** · 08:07
Yeah, that's what I was mentioning. That's why we are seeing is that finance is getting into the into the complex in VFW, uh and that's why there is a delay right now, right? So that's why I have not Yes. So that's why I have not even given a date for the new tables that were identified as well on the new reports, right? So that is one item. The second is Lakshmi, as well as we discussed yesterday as well, until unless we don't close on those three reports, it's very difficult for us to plan and then get started on testing. We are still doing some checks here and there whichever we have re-pointed. That is something we have to do.

**Lakshmi** · 08:50
Yeah, but that's something dependent on you guys to get back with the underlying data structure, right?

**Ravi** · 08:56
Yeah, I think oil trading, Rajeshwari will send it out. Uh, and similarly for finance, we will we will plan it out. By tomorrow, we'll try to send it out.

**Lakshmi** · 09:08
Okay. All right. We'll get into the reports shortly, Ravi. I just want to make sure I just want to make sure that we cover all the other things. So, Manjeet, I know there are certain items still assigned to your name, but I know you're pulled with other things, so I just want to call that out. So, are you Is your timeline getting impacted to complete any of the release committed deliverables because of you getting pulled into other things?

**Manjeet** · 09:39
Uh, so a little bit uh I'm trying to catch up to that. Uh, but uh so so especially around those TMS uh I have to do more, you know, sort of I would say go through the mappings. And then typically I I used a tool, because I had to travel to Gurgaon office yesterday, I didn't get an option to use uh any AI. So, I'll try to catch up that today.

**Lakshmi** · 10:15
Okay.

**Manjeet** · 10:15
As of now, there is a 20 to 30% impact because of, you know, the other activities that I'm getting pulled into, but we'll try to, you know, wrap it up and catch up these TMS stuff.

**Lakshmi** · 10:35
Okay. And uh and yeah, so yeah, let's please make sure that uh this is your top priority right now as we are closer and closer to our QA validations. Yeah, and also uh on the data modeling part, right? What is going on with that?

**Manjeet** · 10:57
Yeah, so the nothing on the data modeling part... Technically there is nothing on the data modeling part... modeling part. Uh, it is more on these tables are on TMS that uh get the corresponding get the corresponding because these are complex. One we have a template for existing BI tables. Using that template, we were able to generate the DBT pipeline, but because these are VFDW tables, the template is not working. So, so we are now trying to go through the Informatica code and maybe just a template adjustment. So, that is where the most of the work is going on. At least for me, it's not about data model.

**Lakshmi** · 11:43
Okay. Then then that If there isn't anything open on that, then can we close the loop on that data models, Arvind? Do we think we should be closing that loop? So, that completes the complete analysis and design deliverables that ops owner has committed for, right?

**Arvind** · 12:03
Manjeet, you updated the you updated the T&L, the employee one as per final?

**Manjeet** · 12:08
So, the for employee one, yeah, that is something which I have to pick up uh after this TMS legwork. Right now I'm focusing on that. There are few career activities, ALM tables. So, I finished uh I think A. I have to focus on the F and then I'll share it to the team. And there are few other things from the views point of view. Then I'll come to the T&L.

**Arvind** · 12:39
Because I need to work with Andre for certain tables. So, I was waiting for I learn that there is one table from Kronos that we get from Kronos, basically uh stale data. Andre was telling me yesterday, so I have to uh confirm with him today.

**Ravi** · 13:00
So Manjeet, so when you update that table in the model and uh send it over, okay? So that we can I mean, we can wrap it up. I mean, there was nothing that stopping so so send it to me, I'll I'll upload.

**Manjeet** · 13:22
Yeah, I think the one approach is probably yeah I'll check with you later, Arvind. How will you getting access to that copilot? Yeah, that will that will help me there.

**Lakshmi** · 13:36
So, so when are we planning So, I know, Arvind, you're here, right? So, so Manjeet, now that once you send the email and close the loop on that, then I can confirm back saying that, hey, this is done. Yeah. Yeah. Yeah, if it's just an email, let's do it.

**Manjeet** · 13:55
It's not email, yeah. Not email, yeah. Had to get the facts. Had to get our facts in place.

**Lakshmi** · 14:02
Okay, so is it going to be today? Because that's a commitment because that's a commitment from you guys, right, for today?

**Manjeet** · 14:11
We only have We only have 24 hours.

**Lakshmi** · 14:14
Yeah, so that's where I'm coming from, right? Because if you if you're being pulled into any other things that is impacting release deliverables, I need to know right away, please, because the timelines are getting pushed and pushed and pushed, so we don't want to push these timelines anymore. We may feel like we have time, but we want to have we want to have some time in the end to take care of any unknown issues, right? Especially when we're doing report testing. Yeah. Yeah. So, Arvind, I'm just calling this out, right? I know Manjeet is a critical resource, a critical resource when it comes to on-site, there's no one other than Manjeet. So, we just want to I just want to make sure that Manjeet is not being pulled into any other things other than release three for the next few days, please. Because I was always told he's under 100% capacity, but I don't think he's 100% in any single day.

**Arvind** · 15:13
See, Lakshmi, we just have to navigate through that, Lakshmi, but yeah we'll try to bring in us because there are some dependencies. See, the complexity is because of this T&L and because it is challenging for others also, and I'm probably after work with Andre to get any details around that. That is what is causing these I would say, once we sort this out, all the development work is being done from offshore. We'll catch up. We'll catch up this week.

**Lakshmi** · 15:47
Perfect. And then can we get these dates as well, Manjeet, for these items?

**Manjeet** · 15:55
Oh, they are assigned to me?

**Lakshmi** · 15:57
They are not assigned to anyone. Ravi had mentioned that these are assigned to you and then you will be providing...

**Ravi** · 16:04
Yeah, I've given Yeah, I've given I've given the initial template code for few. I have to I have to look back. Let me work with Ravi on that.

**Lakshmi** · 16:16
Okay. Sounds good. So, let me ask you this. So, do you anticipate any risk, Manjeet, with all your uh with where you're trying to help the teams as well, other teams as well, and with these open things and with the complexities of VFDWH?

**Manjeet** · 16:36
Um, I don't see risk per se right now. Uh, it's just around, you know, so many things going on. Uh, there are a lot of ad hoc issues that keep popping. Apart from that, I don't see any risk.

**Lakshmi** · 16:51
I need to know about those priorities. So, if you're being pulled into I need to know right away. If I'm not knowing it, then that's a problem, too, because I will be in my mind taking your word, taking the team's word for real, right? I'm taking that hey committed for a certain date, so that's the expectation that it completes. So, but then on the 10th, we don't want to hear that hey, we were doing work on other things, which is why it got delayed, we can't do that.

**Manjeet** · 17:21
Yeah, I got that. First thing is we have a platform that we've deployed as per release 1.0.1, and getting stability to that is a is a critical thing. Okay? So, as long as we are making sure that the platform is stable, then we'll not get into challenges, so that's why so that's why temporary priority shifts is bound to happen, and that's what we are trying to do, is try to cover them, avoid handovers to certain people, hopefully I don't have to get involved more, but I think yeah let's let's uh wait till this week. From next week, I think uh everything will be on release 3.

**Lakshmi** · 18:08
Yeah, where I'm coming from is uh I don't want us to keep repeating the same things again and again, but where I want to go with this is your time is not fully into this. I would definitely take help from Heidi, right? I can go and tell her hey, a resource my resource is being pulled into other things. I understand the priorities, but at the same time, this comes first, so I want to make sure that you're getting the right support. Okay. Yeah. So, having said that, since we have some time, let me go through So, Rajeshwari, do you want to go through your update in terms of report reporting? How come these are Oh, so you've updated this with the 16th report. Perfect. Yeah, go for it, Rajeshwari. Yeah, go for it, Rajeshwari.

**Rajeshwari** · 18:55
Yeah, waterfall table for QA team to start the report, we have re-pointed them. Yesterday, as we discussed, for 7 tables mapping for oil trading test is done that we have allocated in the same sheet mapping sheet. Next one. Next one. Next table. Oh. Next table. You can go for domain. For oil trading, you should be able to find the tables access for each report. Okay? Okay.

**Lakshmi** · 19:35
So, where are the common So, where are the common tables here? I don't see any.

**Rajeshwari** · 19:42
Example, uh third KPI C column KPI score dashboard, right? It can be used in multiple other reports also.

**Lakshmi** · 19:53
Oh, okay. Oh, okay. Okay. So, if since you have this, uh so who is going to meet with Arvind to get this sorted out? We have 10 minutes, we can do it either now. 10 minutes won't be enough for sure. So, who's going to who is going to meet with Arvind to get this uh filtered so that we can then go back with the filtered list to Andy. So, Manjeet, do you think you'll have time to do that today or will Ravi have to do it with Arvind?

**Manjeet** · 20:29
Uh, in the morning time I think I'm I mean next couple of hours I'll be occupied, so I think uh Arvind and I can probably No, can can... Okay. 1 minute.

**Lakshmi** · 20:45
So, I can schedule something.

**Manjeet** · 20:49
Ravi is available, Ravi can you and Rajeshwari close that in the morning?

**Ravi** · 20:55
Actually I have back-to-back uh let's uh let's do this in the afternoon. You and me will connect, Manjeet. You and me will connect, okay? Uh, let's connect around like 4:00.

**Manjeet** · 21:08
Sure.

**Lakshmi** · 21:10
Okay. So, I so I'm not scheduling anything, so probably you guys can ping each other and then meet. So, that's an action item for Manjeet...

**Manjeet** · 21:22
Sorry, Lakshmi, so what is the action item here? Uh, just finalize in the report, right?

**Lakshmi** · 21:28
Yes. So, basically uh the list, just to be clear, since we have a total count of 62 now, and given the timelines, the team is committed or planned only for 50 report testing. There are 12 additional that we need to see if we can reduce the count. In order to go back to Andy, we need to make sure which ones are having the common tables underneath. So, that is the exercise that Rajeshwari did and she came up with all these details, right? So, now the next step is for you to meet with uh meet with Arvind and go through these tables and see which ones and see which reports can be skipped and they can take it as part of QA because all the tables would have been tested in other reports and the other reports will be tested by us. So, if we know those report names, then I can go back to Andy and then we can ask him, "Hey, these are our observations, so let us know what you think." And they are not going to count them as anything like a request. They are not going to tell on that count. It's going to confuse It's going to confuse. We're going to just make a conversation saying that hey, these underlying tables are already tested and taken care by other reports, so we're going to test all these reports, so the other reports we will help you validate. That's how we want to take the conversation, right, Arvind, based on our alignment yesterday?

**Arvind** · 22:51
That is correct, yeah. We'll connect on that. Before we connect to Andy, let's uh let's uh we will discuss and then connect to them.

**Lakshmi** · 23:01
Yes. Yes, yes, not the call, yeah. So, Manjeet, if you can do that exercise, I'm clearly mentioning that it's a critical step. QA team is waiting to test the reports, right? Let's close that out and offshore team will have all these details ready for them to take up the reports. Okay. Sounds good. Sounds good.

**Rajeshwari** · 23:23
One more thing was like for the priority one, I see the number of reports have increased now. Initially when we were doing analysis, right, we had around close to 30 reports or something, now it has increased to 63 reports.

**Lakshmi** · 23:41
Okay, I think you're repeating... Can Ravi fill in Rajeshwari?

**Ravi** · 23:48
Yeah, yeah, Rajeshwari, that's what I was telling. That is the same uh that is the same uh discussion, Rajeshwari. That's what we are sharing and we will reduce it. Yeah. Yeah.

**Rajeshwari** · 24:02
Yeah.

**Lakshmi** · 24:03
Okay. Any other questions, concerns from the team? Okay. If there aren't any questions, concerns, then I'll give back everyone 6 minutes. Thank you so much.

**Ravi** · 24:18
Thank you.

**Arvind** · 24:19
Thank you.

**Manjeet** · 24:19
Thank you.
