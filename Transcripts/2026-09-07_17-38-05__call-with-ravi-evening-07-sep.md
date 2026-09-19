---
title: "Call with Ravi Evening 07-Sep"
recorded: "2026-09-07 17:38:05"
context: "Kaushik, Ravi"
watch_for: "Action items for each person"
duration_seconds: 865
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
has_my_notes: yes
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 4 min of speech
  - "Speaker 1": "?"  # 12 min of speech
status: summarized
speaker_evidence:
  - "Speaker 1": "Provides detailed instructions and confirms actions multiple times."
---

## My notes

_Typed by hand during or after the meeting. Authoritative where it conflicts with the transcript below._

- Dev team to run recon in QA env itself
- Wants Arun to start running the recon, should have access by 09 Sep, Kaushik to have him connect with Shashvat and have him grant access
- Reports - we have said we will not do >50

## Transcript

**Speaker 1** · 00:00:00

to start running the recon, okay, in QA environment itself, okay, and while they are running the recon, we just capture those results, and we can then see whether it's passing, failing, whether there's any comments or not, and we update our results, for example, I just pinged you the location to that, okay, so like Mohit has already done, run for all the oil trading tables, okay, one or two, he said that there's some issues he's looking into it, so we capture that as execution, I also want Arun to start running that, okay, so we have to enable him to run this as well, so maybe he should have accessed by tomorrow, or actually by day after, because they are on leave today, right, Manjeet had been following up, So, let him get the recon utility, everything installed by then, okay, have him connect with Shahid and get the recon utility installed, okay, anyway, the developers, I'm asking them to run the recon, so we will have the results, it's, Arun being there is just another layer of

**Me** · 00:01:19

Yeah. Yeah.

**Speaker 1** · 00:01:20

Validation, okay, okay, and I will do the similar with Rajeshwari and Arun for the report testing, again, his access should be in soon, let me talk to Rajeshwari, and we will get started on the report testing as well, so, whichever one is finalized, we should get started with that, okay,

**Me** · 00:01:45

So report testing will start only after the gold layer tables are created and populated, right?

**Speaker 1** · 00:01:45

No, no, no, no, no, we can, we can do it in parallel, that's fine, doing it in sequence is going to just delay, like if they have an issue, sometimes it might not show up in the data layer, or it might show up in the reporting layer, right, so, let's not waste time on that, or vice versa, right, reporting might be dependent only on some metrics, some columns, while, yeah, the data might be dispatching in some other columns, so, yeah, we will, let's do it in parallel, let me talk to Rajeshwari, I'll try to figure out where we are in terms of all the repointing, and we will try to get that going also, okay.

**Me** · 00:02:30

And then, uh, are we working on those on priorities?

**Speaker 1** · 00:02:32

No, no, no, there's nothing specific, they just given us the report names, so, we have to compare the DB2 and Snowflake, and we have to run it. Okay, so, it's a manual verification, that's the reason it's a little manual, because there's no specific fixed, you know, test cases we have right now for that. Okay, so, I had already highlighted the risk that they are not closing on the reports, okay, so, if you go to the sheet, the tracker, okay, look at the ones which are marked as number one,

**Me** · 00:02:55

Um, yeah, I think what I am basically curious about is, uh, if there are going to be any delays, then we can just highlight the same to Lakshmi beforehand.

**Speaker 1** · 00:03:17

I think they were supposed to reduce that account, but I don't think they are yet to, they have yet reduced that.

**Me** · 00:03:27

So who is that POC on the reporting part?

**Speaker 1** · 00:03:27

Let me just check what's the count right now.

**Me** · 00:03:34

Like whom, who, who is the POC on Ventura side?

**Speaker 1** · 00:03:34

POC in a sense?

**Me** · 00:03:38

Like whom are you referring to that they have to come close?

**Speaker 1** · 00:03:40

It's, it's, it's, it's Lakshmi and Aravind, okay, they have to coordinate with business, and they have to close on it.

**Me** · 00:03:48

As in just a land, uh, narrowing down the list of reports that are P1 is what.

**Speaker 1** · 00:03:51

Correct, correct, so, right now, if you go to the report tracker, in the same sheet, right, you will see 62 reports, okay, we have said we will not do more than 50.

**Me** · 00:03:56

Yeah.

**Speaker 1** · 00:04:02

Okay, so, my point is that, beyond that as well, we can, meaning, whatever reports are there, it's already repointed, we should just go in and go ahead and start testing it.

**Me** · 00:04:11

Hmm.

**Speaker 1** · 00:04:12

Okay, so, we are not getting delayed from our end. Okay, so, let me first talk to Rajeshwari, let me figure out where we stand, and then we can get started on it.

**Me** · 00:04:25

Is it until the 21st of September or is this for?

**Speaker 1** · 00:04:29

It's for 21st of September, see, if we, if we have Rajeshwari, Arun, and another person doing the validation, I'll try to get another, one of those BI guys to do it, even if they do two, three reports each, right, it should not take us more than six, seven days to finish that. Okay, so, that's why I'm, and majority of the times I have seen that most of the reports work, there are one or two reports which get stuck. So, yeah, so, I believe it should be fine, but I think we have to get started now.

**Me** · 00:05:06

Okay.

**Speaker 1** · 00:05:06

So, data recon, I have anyway, gotten it going, so, we can also start updating the status. So, report part, what will happen is that if it's, if it's like a dashboard kind of thing, right, we will compare the DB2 report and the Snowflake report.

**Me** · 00:05:12

Um, so in the reports part, uh, what would it constitute that we just, uh, for my understanding?

**Speaker 1** · 00:05:29

Okay, so, there will be different, say, for example, chart elements and everything, we look at the values and some KPIs or something and say that, okay, these matches, so, this looks good. Okay, we'll take some screenshots and then we will close it, okay, it's manually, okay, the second way is that we take the grid report, meaning if there are grid reports, we download the data from both reports, okay, and we have a simple pipe script, we just ask it to do the comparison between the words.

**Me** · 00:05:41

So this is my manual only. Yes. It's good.

**Speaker 1** · 00:06:01

Okay, so, that is the way we do it, we had built a vision agent last year, not last year, early this year to carry out report testing. But the only issue was that, you know, since it was using an LLM, and it was using our LLM, right, it was basically, and these are reports, right, so, these are financial reports, sales reports and everything.

**Me** · 00:06:25

Okay.

**Speaker 1** · 00:06:26

So, it was essentially taking the data and sending it to a LLM. So, we then shut that down because that is just exposing us to risk tomorrow, right, if they get to know it's an issue. Yeah, yeah, yeah, they're not okay with it, meaning, you know, now companies, okay, sending it to an external LLM, and at that point, they had not started the AI journey. Okay, so, now, they are just getting that going, so, now, maybe in a few months' time, we should be in a position where we can do all this, but, as of now, we are not there yet.

**Unattributed** · 00:07:00

Okay.

**Speaker 1** · 00:07:04

Yeah, but local version, meaning, see, if I am to use an LLM, I cannot use it. Okay, so, that's why we are either doing a manual way of validating it, the visual elements, right, or we are downloading the grid reports and comparing it using Python. Okay, so, those are the only two methods we are using.

**Me** · 00:07:25

There must be some, I mean backend script also, right? For each report. Can we, but okay.

**Speaker 1** · 00:07:31

Backend, yeah, yeah, yeah, yeah, see, if you have, when you have to do the defect, the issue debugging, we use the backend SQL.

**Me** · 00:07:33

Okay.

**Speaker 1** · 00:07:40

So, we'll try to look at, you know, which cube it is using, what is the SQL of the cube, then I will run it against DB2 and Snowflake and try to understand why there's a difference. Okay, so,

**Me** · 00:07:53

So just maybe coming back to the reports, even, even if we want to do 50, uh, uh, uh,

**Speaker 1** · 00:07:54

so, yeah. Hmm.

**Me** · 00:07:59

what we have like, uh, around 10 working days left.

**Speaker 1** · 00:07:59

Hmm. Yeah, yeah.

**Me** · 00:08:04

That is five reports per day.

**Speaker 1** · 00:08:06

Yeah.

**Me** · 00:08:07

If we start today, that is.

**Speaker 1** · 00:08:10

Yeah, yeah, I think, I think we have to, yeah, I think we should be able to complete. My only worry is that there are many, many of these financed reports and everything they have are newly added, for which there are new, many, lot of new tables that have been unearthed. Okay, so, those are the ones I am a little worried about, but I am looking to get the original finance, PCS, and oil trading ones done. Those are the critical ones. Okay, so, let's get that finished, while we get all these other ones sorted out. Okay, yeah, I will talk to Rajeshwini once and figure out where we stand and then I will let you.

**Me** · 00:08:52

Uh, and I think another item on my list was to just go through the defects for, uh, bronze

**Speaker 1** · 00:08:52

Okay. Okay. Mm-hmm.

**Me** · 00:08:56

and silver. So I had already dropped a message on the group in the morning regarding each table that

**Speaker 1** · 00:08:58

Mm-hmm.

**Me** · 00:09:02

is still open.

**Speaker 1** · 00:09:02

Okay.

**Me** · 00:09:04

Uh, so yeah, I'm just seeing what, what is left because, uh, I think the only issue,

**Speaker 1** · 00:09:08

Okay. Okay. Okay.

**Me** · 00:09:16

only tables that I still have, uh, still don't have clarity on is the 80201 and the DDFPRDVV1. Basically these issues, uh, so at least in the second one, the DDFPRDVV1, there is one, uh, two columns from the source layer have some special characters at the end of them. And then they are getting converged into a single column when pulled into the bronze layer.

**Speaker 1** · 00:09:39

See, this looks like a product bug, but, if that's the case.

**Me** · 00:09:41

So this superior told me is an issue at the five, 10 issue with the five, 10 part. And that he says is not with us. Right. We have to raise it to an external team. So whom do we raise it to? And what is this process? Yeah. But like there should be a, there should be a functionality for adding an exception.

**Speaker 1** · 00:10:04

Okay.

**Me** · 00:10:07

Right. And basically like an edge case when the ingestion is happening.

**Speaker 1** · 00:10:09

Yeah, have we, meaning, has anyone given the details in the chat? I don't see it.

**Me** · 00:10:22

If you can see.

**Speaker 1** · 00:10:24

Yeah, okay, I'm looking at that.

**Me** · 00:10:27

Under at Atul point number four.

**Speaker 1** · 00:10:32

Okay, okay, okay. Okay. Okay, let me check on this. We can open a ticket with the, you know, Pytran support, but I don't know how good that will be.

**Me** · 00:10:49

Yeah. Yeah. I think that I have the same issue for both point, points numbered, uh, three and four. So maybe if you could look into both of those.

**Speaker 1** · 00:11:01

Okay. Point number three, I think we said it has data in DB2. Okay. Oh, okay, okay, this is one time load.

**Me** · 00:11:10

I mean, even if it's a one time load, uh, somewhere with the ingestion part, only there is some issue.

**Speaker 1** · 00:11:17

Okay. Okay.

**Me** · 00:11:25

2001.

**Speaker 1** · 00:11:26

Hmm. God knows when, these guys have left it as it is.

**Me** · 00:11:34

Yeah.

**Speaker 1** · 00:11:36

Hmm.

**Me** · 00:11:36

Yeah.

**Speaker 1** · 00:11:36

Hmm. So, I did not understand this.

**Me** · 00:11:39

And, uh, there is one item that I had tagged you also as well. Uh, the JDE underscore F4 triple one.

**Speaker 1** · 00:11:49

So, this is F4, meaning 4111. I know there's an issue in production also going on. Okay, so, so, this one, I'm not sure why, is it coming?

**Me** · 00:12:04

No, he said there is some branch table that needs to be built that is not built yet.

**Speaker 1** · 00:12:07

Go ahead.

**Me** · 00:12:10

So he can't, uh, do QA for this.

**Speaker 1** · 00:12:15

No, no, but tell me, 4111, it's a table already in production. Okay.

**Me** · 00:12:22

Hmm.

**Speaker 1** · 00:12:22

So, I would rather we take this out of this, our scope, because there is an issue going on, because FyTran and 411, meaning there is an issue with FyTran. Okay. So, they are rebuilding the whole thing with IDNC right now, in production.

**Me** · 00:12:45

So let me talk to data upstream.

**Speaker 1** · 00:12:45

Okay. So, I would rather we take it out.

**Me** · 00:12:47

I will send a note to Ergun about this.

**Speaker 1** · 00:12:53

No, we are building it. We are trying to solve it. So, let me talk to data upstream. If required, I will send a note to Oregon about this. Okay. Yeah. These are the only two tables, right? The Kronos is the Kronos one, 4111, and the other one, yeah. Okay. Okay. Okay.

**Me** · 00:13:19

Sure.

**Speaker 1** · 00:13:20

Anything else pending from Brunson?

**Me** · 00:13:22

From bronze and silver? I think whatever I posted, all of that is pending, but some of them are under fix and I think one of them is already fixed. Some changes I think.

**Speaker 1** · 00:13:33

Okay. Okay. Okay.

**Me** · 00:13:37

Thanks. I think we, tonight we won't have the meeting.

**Speaker 1** · 00:13:38

Okay. Okay.

**Me** · 00:13:40

We'll have the meeting tomorrow night because it's a holiday for them.

**Speaker 1** · 00:13:40

Yeah, yeah, yeah, yeah, yeah, yeah. That day, did we have the meeting after then?

**Me** · 00:13:46

So I, on Friday, I don't think it started soon. I think it started after 9.30 and I don't think I was able to join, but I spoke with Lakshmi before.

**Speaker 1** · 00:13:56

Yeah, I saw my calendar refresh late in the night.

**Me** · 00:13:59

So yeah, she just wanted me to close on, um, uh, well, just, uh, ensuring that we are on

**Speaker 1** · 00:14:00

That's when I saw it at 9.30. Okay, okay, okay. Okay. Okay.

**Me** · 00:14:12

track to close by the 21st and just highlighting any issues beforehand.

**Speaker 1** · 00:14:14

Yeah. Okay. Okay. Okay. Thank you.

**Me** · 00:14:20

Thanks.

