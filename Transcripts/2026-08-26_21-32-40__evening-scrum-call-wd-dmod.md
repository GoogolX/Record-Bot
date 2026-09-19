---
title: "Evening scrum call WD DMOD"
recorded: "2026-08-26 21:32:40"
context: "Me, Gayatri, Trinadh, Abhay"
watch_for: "Overall status and person-wise priorities"
duration_seconds: 1153
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Speaker 1": "Gayatri (high)"  # 11 min of speech
  - "Speaker 3": "Abhay (high)"  # 4 min of speech
  - "Speaker 2": "Trinadh (high)"  # 4 min of speech
speaker_evidence:
  - "Speaker 1": "addressed as Gayathri/Gayatri multiple times by Speaker 2"
  - "Speaker 3": "Speaker 1 says 'let's go over Abhay's tables' immediately before Speaker 3 responds with table status; only remaining name in context list"
  - "Speaker 2": "directly addressed as Trinath/Trinad by Speaker 1 repeatedly, responds about PO column work matching Trinadh's known assignment"
status: summarized
---

## Transcript

**Speaker 1** · 00:00:00

CDC dates and today's updates and what all are our assumptions on CDC dates Hi Abhay Trinath

**Speaker 2** · 00:00:09

Hello Hi

**Speaker 1** · 00:00:12

Trinath and Abhay when you guys discuss the 28th is coming out to be okay like what is the assumption Trinath you will still spend time on PO tomorrow and then get to CDC or CDC from tomorrow

**Speaker 2** · 00:00:31

No no I think PO will take tomorrow also

**Speaker 1** · 00:00:34

All day

**Speaker 2** · 00:00:36

Mostly yes because the problem is like most of the columns like so far I have done 20 columns so everything is hard coded as zero in the code but in the table we are getting the data so we don't have the code where we are updating that particular column so that is the main challenge like we are converting we are taking the EDW code from D and F table right I mean that purchase cost D purchase cost F tables population code we are taking and we are converting that as AWS but in that particular code that was hard coded as zero so as per that logic we should have only zeros in the table but when we check the table we are getting the data

**Speaker 1** · 00:01:24

and there is some more workflow meaning some case when it will be zero another case so the other basically we haven't received that from funny then

**Speaker 2** · 00:01:33

yes so some of the utkarsh columns like utkarsh on utkarsh name I can see 20 columns so most of them are like that so gathering the code is taking a lot of time

**Speaker 1** · 00:01:49

but gathering the code is from whom

**Speaker 2** · 00:01:51

like previously we have asked harsh and funny in the group chat right so those all the charts I am going through and checking like we have a Pivo closer group

**Speaker 1** · 00:02:06

you might still need more information from them right

**Speaker 2** · 00:02:10

correct that is true

**Speaker 1** · 00:02:12

then Trinath if you can get that whatever information you need tomorrow morning then it will be better because they take some time to share as well

**Speaker 2** · 00:02:19

yeah I tried calling Fani Gayatri today because I will ask Fani to share all the code where they are updating this D and F tables so instead of me going every time like when I see a new code I am going to Fani and Fani is a little busy so instead of that I will ask Fani share all the code where you are updating this D and F tables so that way I think it would be easy for us

**Speaker 1** · 00:02:43

did he get back

**Speaker 2** · 00:02:45

no not yet

**Speaker 1** · 00:02:47

and he is in

**Speaker 2** · 00:02:51

back to back calls I think like I am watching him yeah

**Speaker 1** · 00:02:54

he is supposed to be on leave today okay okay yeah yeah let's keep following up if you can get it on time otherwise at least otherwise you reach out to Zabi that this is what I need

**Speaker 2** · 00:03:19

okay okay

**Speaker 1** · 00:03:21

yeah let's go over the sheet can we go over Abhay's tables and update the latest status

**Speaker 3** · 00:03:38

yes yes so dim supply site is done can close this

**Speaker 1** · 00:03:47

can you filter out the status column Kaushik I want to see all the tables that's on okay

**Speaker 3** · 00:03:54

so the pending supplier I'll I'll just need to validate the code which did not have given me so that I'll do the bigger chunk is on organization so organization is in a very messy state the dim the dev and QA they are not even matching on the schema level so I think

**Speaker 1** · 00:04:26

he mentioned that QA1 is what we need to

**Speaker 3** · 00:04:31

take right right but actually the logic is not matching up to the mark that dev is matching so they are quite closer to EDW as compared to what we have in QA so possible reasons which I could get is that there are changes because legal entity have merged I guess so joints etc are changed but I think QA will work once silver is refreshed also I guess silver is not refreshed in QA so that lack data mismatch is so idea is that dem organization now I analyzed this will take a lot of time right so idea is that I convince it should go into a full load the reason is that 20 sources are

**Speaker 1** · 00:05:31

the team

**Speaker 3** · 00:05:32

right but

**Speaker 1** · 00:05:33

logic of recommending it should be a full load should be not that we are not able to do CTC

**Speaker 3** · 00:05:41

right right right so dem organization uses 20 sources right 20 silver sources or 20 silver sources 17 sources are around 5k is only it's like 50 60 rows only so I have full frame out and we will go through it but dem organization if I will start I don't think I will be able to finish it in even 2-3 days because the cost I mean the effort versus the output that is not substantial

**Speaker 1** · 00:06:23

effort versus output is constraint now when you recommend CDC framework of deciding or rational of deciding CDC or irrespective of effort because this is all one time don't don't bias it on that we shouldn't do actually that is what we should be recommending

**Speaker 3** · 00:06:46

right so what I told internally I told whatever framework I decided it is purely on the numbers only the sources are even if I do CDC the time that it will take almost full load so that is one also it is sticky flags logic right so sticky flags okay so

**Speaker 1** · 00:07:14

we can close this topic

**Speaker 3** · 00:07:17

and

**Speaker 1** · 00:07:19

there was one more table that was saying that full load and that is little time versus this whatever so I think these two tables have conclusion with funny can we just color code that separately dim organization column N and check with funny and red what about supplier

**Speaker 3** · 00:07:45

supplier I'll just validate I guess Trinath has already done the coding part so I'll just validate it will not take a lot of time

**Speaker 2** · 00:07:52

next up I'll start with employee and one more thing on CPN

**Speaker 3** · 00:07:56

reconcile he just confirmed we can take it as full load because otherwise CDC will close

**Speaker 1** · 00:08:02

I guess

**Speaker 3** · 00:08:05

CPN leave inside if we use full time

**Speaker 1** · 00:08:08

yeah we have updated as full load okay can we get to once now to this fixed data issues we have status or old status

**Speaker 3** · 00:08:25

I think

**Speaker 1** · 00:08:34

probably this is old status right

**Speaker 2** · 00:08:36

sorry sorry sorry what is the issue

**Speaker 1** · 00:08:50

basically IR line fixing data issues you know

**Speaker 2** · 00:08:53

no not sure who has written this one I have not written

**Speaker 1** · 00:09:01

I think we have, we have, in old status, completed open, like this was a regular table status, we have repurposed with CDC completed and CDC status also, so just check if these are old statuses, and in that case, basically, after div, you have got GR line, IR line, and purchase requisition line. Did you discuss this with Sharath?

**Speaker 3** · 00:09:32

No, no, I think GR is not on me. CDC owner is Trinath for this.

**Speaker 1** · 00:09:37

Can you just confirm on the, basically filter on the new owner, Koshik, you're not filtering it properly.

**Speaker 3** · 00:09:44

So I guess I have two fact tables on me. One is on 28. What I think is that if I'll get to the employee in the first half tomorrow, fact purchase requisition line, then I'll definitely do. Fact invoice receipt line depends upon what are the issues. I'll try to have at least the coding part done for both the facts along with all the DIMMs, if not validation.

**Speaker 1** · 00:10:15

Actually, I don't mean coding complete. Unless you're not coding validation and you're passing it to somebody else, it becomes a rework for them also. I would prefer that you're coding and validation both complete and you move to the next one. Because there is still 20% probability, 30, 30% probability that there is a coding error that you will understand and it will be faster. So you wrap up. You let us know. Okay, let's move to Shubham and Trinad. So we are assuming Trinad is getting into CDC tomorrow. So this will most likely happen on 28th. 28th only. Shubham 28th, 27th. Also two things, three things have been put on Shubham.

**Speaker 2** · 00:11:17

I think those Fat Delhi exchange, Global exchange don't take much time.

**Speaker 1** · 00:11:23

I think that's three things. No, no, no, no.

**Speaker 2** · 00:12:01

I think Sharad did some analysis and then he has given these dates. I think Kaushik.

**Speaker 1** · 00:12:11

I think this is what I asked Kaushik and Trinad that depending on every person's constraint, let's put dates. Two per day is what I have been trying to do every other day and we are not able to meet. And my main thing is QPO, we have to do it. That's what I had to do with Shubham. So like Dev issues we will still have to do. But QA issues, I need to transition it back to WD team. We can't keep doing that because they are late. Why is QTest starting on Monday? There is a lot of QTest activities there and they have not given us any time for that. So basically, we needed four straight days for Trinad and Shubham to do CKC and they are getting stuck in some of the other things that are happening. And if Fanny has not sent in the complete PO line code, Trinad, and if you have to re-ask, then you should also let him know that when we asked before, why did he not give it? When Utkarsh was writing it, if he did not have the full workflow, then that is Fanny's fault also, versus if he knew and if he missed it or whatever.

**Speaker 2** · 00:13:34

And one more, Gayathri, can we ask them to push testing QA? Because let's assume we have raised the bugs on 20-30 columns. So if these 20-30 columns are not getting used in Power BI, then fixing this doesn't make any sense also, right? I mean, we are not using all the columns in Power BI dashboard, right, Gayathri?

**Speaker 1** · 00:13:56

Gayathri, this conversation would be funny because it is the first thing that you don't have to do time-waste, and you don't know what they are doing.

**Speaker 2** · 00:14:04

Okay, okay.

**Speaker 1** · 00:14:06

Because QTest is not the issue in the QTest, so if we are creating that column, might as well do it like Power BI. But you have that conversation, are these getting used, and do we need to prioritize? Okay, I'll set up some time with Zabi tomorrow, where we will mention that this is going to be going. Try having a conversation with Fanny in the morning only. So before we meet Zabi, we know what is going to happen. If we are dependent on anything, we can tell Zabi that these are the things that we need. If you are still waiting in on things, you get started with some or the other, CDC, whatever is tagged on you.

**Speaker 2** · 00:14:52

No, no, tonight I'll connect with Fanny Gaitrain. Tomorrow again.

**Speaker 1** · 00:14:56

If he is available, maybe if he is just joining some leadership calls, US, and he might just log off after that. We will talk with Hari and Michael Satish. Because he is a public holiday.

**Speaker 2** · 00:15:11

Yeah, I got it.

**Speaker 1** · 00:15:13

Anyway, if you get a hold of him today, then perfect. If not, tomorrow. But his tomorrow morning is also kind of busy only. Yeah, that's right.

**Speaker 2** · 00:15:22

Tonight only I'll try to connect with him. And we can inform Shubham to complete these two tables. Like fact, daily exchange, global exchange. I think it will take a couple of hours only. So that way I think... I think some Qtests issue.

**Speaker 1** · 00:15:34

I think Shubham should be able to free up the main Qtests. I think transition from Fanny's team to anyone. Ideally, we should have not spent two, three days there. One day, it's okay, PDH. But up to anyways, two, three days, we are gone. Procurement, procurement with BPA, Qtests issues are coming. So they need to know what to do about that. And the whole one week in between, they didn't start on Qtests. So they could have also raised a week earlier. Yeah.

**Speaker 2** · 00:16:00

And I don't know, for PDH only we got these many issues for procurement and other data sets.

**Speaker 1** · 00:16:06

But PDH was a lot of silver-bronze problem, right? Yeah, yeah, yeah, I agree. So, it means, if you're going to spend your time, somebody from their team should be doing all of this. Let me actually block some time in the afternoon with Zabi on this.

**Speaker 2** · 00:16:25

And Gayatri, any extension after 31st?

**Speaker 1** · 00:16:28

No, no. Trinath, I only don't want to do, so please don't propose or don't consider.

**Speaker 2** · 00:16:32

No, no, no. Gayatri, because this is very hectic. But the thing is, again, if, let's assume on Friday or Monday, if they come back with some Qtests.

**Speaker 1** · 00:16:41

Yeah, so that's what I'm saying. Qtests are not closing. And we had very clearly told them a month before that we will be out. So Qtests and the one week in between where we have given them PDH and AP, they had not moved it to Qtests. So, Qtests issues, they have started this Monday. So, anyways, I feel that procurement and procurement with BPA Qtests will not be over. So, they will have to manage it. So Qtests, we should transition as soon as we can. Basically, after the first half, Sribam shouldn't be working on Qtests. They should have identified somebody from their side who is investigating these things. Ideally, what is the investigation, Sribam has done it. We should have aligned internally and he should have identified Sribam. We should have identified somebody from Fanny's team to analyze what the issue is. And whatever gold issue is there, that we could have corrected. So, at least, it becomes investigation time or CDC becomes complete. But I want to just close it, Tarnad, however. In fact, our other project is a bit delayed. So, I'm thinking even if you guys need Saturday Karo, 31st, that week, we should take light. Just read documents from that new project, understand people and all of that, and plan out slowly.

**Speaker 2** · 00:17:51

Okay, okay.

**Speaker 1** · 00:17:53

But formally, we will say, though you both will be there, so I think they'll know. Because I'll move, I'll move them, move you guys under Shambhu or Abhishek. So, he'll know that there is something there. But yeah, Qtests less transition. Deb, we will still have to do, so if there's anything coming on PO, IRG or what you want to do, but PO also, if you close tomorrow, hopefully nothing there.

**Speaker 2** · 00:18:24

Yeah, yeah, sure.

**Speaker 1** · 00:18:28

Actually, can we just do new owner as Shubham again once? So, AP transaction, he was going to wrap up today, which he might. Procurement, IRGR, balance, balance summary is not needed. I think he will be able to wrap up tomorrow also, maybe, with some open IRGR issues and these two. I think this will be going to happen. Tarnad, you figure out, if there will be something else, you will keep us in the loop. So, we will have to just move things around a little bit.

**Speaker 3** · 00:19:00

Okay.

**Speaker 1** · 00:19:01

Okay, guys. Thank you. Bye. Thank you.

**Speaker 3** · 00:19:07

Bye.

