---
title: "Call with Sayli and Arunkumar to discuss Report QA"
recorded: "2026-09-11 11:02:09"
context: "Kaushik, Arunkumar, Sayli"
watch_for: "Action items for each person"
duration_seconds: 581
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 6 min of speech
  - "Speaker 1": "?"  # 4 min of speech
  - "Speaker 2": "?"  # 3 min of speech
  - "Speaker 3": "?"  # 44 sec of speech
  - "Speaker 4": "?"  # 31 sec of speech
  - "Speaker 5": "?"  # 9 sec of speech
  - "Speaker 6": "?"  # 5 sec of speech
status: summarized
speaker_evidence:
  - "Speaker 1": "Multiple references to Arun and validation of reports."
  - "Speaker 2": "Mentioned checking specific reports and responding to Kaushik's questions."
  - "Me": "Identified as the organizer and leader of the meeting, referring to others by name."
---

## Transcript

**Speaker 1** · 00:00:00

or something like that. Yeah. Yes. I'll do that. Sure. Sure. Yeah. Yep. Mm. Mm. Mm. Mm. Mm. Okay. Got it. Well, got it. Mm. Mm. I'm still. Koshik, I wanted to like point out one thing. Like yesterday Rajeshwari has given one report I'm not able to see here like oil contract percent. Some report was there, right? Actually, she only she told take this report because that report was ready.

**Me** · 00:00:00

Okay, can you just raise this in the group and just tag Rapp as well? So whatever issues that any of us are facing throughout this entire week, we have what, so my calculation is like this, so we have six working days, excluding Monday, until the 21st, and we have 52 reports and three of you are working on this. So Rajeshwari is going to leave today, but she'll be available from Monday. So that basically means that we'll have to ship out approximately three reports every day. So three is a good target, but I would say try to finish as much as possible, like more than three should be good, because later on we might encounter other ad hoc issues as well that you guys might have to work on, reports related only, maybe you'll have to revalidate reports that you identified effects in and hand over back to developers and so on. So I would say just whatever time you have right now, make good use of it and finish everything Understood.

**Speaker 1** · 00:01:22

That is in prod and dev also. So I started with that report yesterday. So that I was searching that report. I'm not able to see here like whether I'll check with her. I'll ping and I'll ask her. Okay. And one more thing, Koshik. Yeah. No, no, not done. I was checking like this is a quite new for me. Koshik. I haven't done anything on report and MSTR. So I was checking on that. So that was like nearly like it is done. So I am like still I'm validating

**Me** · 00:01:33

So we have a tracking sheet, Arun. So there are a lot more reports in the entire list, but for the scope, for the sake of this particular release, we are considering only these 52 reports. So I'm again, not sure why she was validating that particular report, which she shouldn't have. But if you've already done it, well and good, it's fine.

**Speaker 1** · 00:02:17

row by row. It has like around 1800 rows in prod and dev. So we need to validate each row. So that is I'm a that is in progress. So I'll check that one. And I know that tool is I'm not able to install that tool in Mac Koshik. I don't know like I am

**Me** · 00:02:32

You're not doing it manually.

**Speaker 1** · 00:02:39

figuring out that one. You were able to install like Koshik like that that in Excel, we look up we can use that one also.

**Me** · 00:02:45

But Arun, if that tool is not working, it's a simple comparison tool, right? I mean, there must be some primary key based on which you are...

**Speaker 2** · 00:02:59

One more. There's one the the the one Python file which Rajeshwari sent yesterday on that group. So is it working?

**Me** · 00:02:59

Or let's just use Claude to build your own tool, right? I mean, I'm sure there are other tools that exist that are open source that you can just use directly.

**Speaker 1** · 00:03:17

It's the working one or it's not? Not sure. We need to check that one. I don't know who has used that one.

**Me** · 00:03:27

Yeah, Arun, definitely do not do it manually.

**Speaker 3** · 00:03:28

Okay, Koshik.

**Me** · 00:03:30

There is no point. We need to spend some time on figuring out and getting the script to work. Do that. And reach out to Ravi if you need any help. Or just like drop a message on the group tagging me and Ravi. But yeah, definitely don't spend any time malaging 1,800 rows manually. So I just, in this call, wanted to understand whether Arun, you are good? Like access-wise, environment-wise, everything is okay?

**Speaker 2** · 00:04:02

I'm good, Koshik. Yeah, but I wanted to know that from like which reports should I start? The above ones if you see, they're having

**Me** · 00:04:04

And Saili, you too?

**Speaker 2** · 00:04:13

some QA data is blocked at the above ones, right? And okay. Okay. Yes, understood.

**Me** · 00:04:18

Yeah, yeah, yeah. So TMS, I think, should be ready. The data should be in QA to be consumed. So maybe start with those. If you are encountering any issues, just drop a message on the group. Just check for all the reports against your name and go domain by domain.

**Speaker 4** · 00:04:37

Understood.

**Speaker 1** · 00:04:37

Koshik, can we know like which are all domain we have data like here like in the next column then?

**Me** · 00:04:45

Yeah, yeah. I will, I think that this is already there, but I have to update this. So I'm just waiting for Ravi's response.

**Speaker 1** · 00:04:51

Okay. Because for everything, it is no only. Sure. And also, Koshik, like we need one more thing. Like can we ask Ravi for like hold documents like how they were

**Me** · 00:04:54

Yeah, yeah. But I mean, I had a discussion with Ravi yesterday. He said TMS data load was running yesterday, so it should be done by now. Oil trading, he said, is done. So this, I will again re-verify with him and check. But you can also maybe check from your side, right? Just see if the report is loading and if you are able to see the data.

**Speaker 1** · 00:05:20

doing like what are the parameters they were using. Like if any one document it is there, like we can follow that document.

**Me** · 00:05:28

So I checked with him on that also. So he said it's a little bit of a mess only, whatever documents were there before. It's all a jumble, so he couldn't find anything. What I can tell you is check with Rajeshwari.

**Speaker 3** · 00:05:39

Sure.

**Me** · 00:05:42

Like just call her directly and ask her what usually these documents should contain and go by whatever she directs.

**Speaker 3** · 00:05:43

Sure.

**Speaker 2** · 00:05:51

We need screenshots also, right? Or just.

**Me** · 00:05:51

So there are, I think, three types of reports. So two types of reports, grid reports and graphical reports. For grid reports, you just do a row by row recon. For graphical ones, yeah, you take screenshots and put them in a document.

**Speaker 4** · 00:06:06

Okay. Got it.

**Speaker 1** · 00:06:12

One more is dashboard, right? Yeah.

**Speaker 2** · 00:06:14

I think dashboards only contain this graphs and all, I think. Because grids will be normal table format, SQL cubes.

**Me** · 00:06:16

I don't, I don't remember. Yeah, exactly. And there is a third type of report that basically directly hits the source. It doesn't hit our silver or bronze layers or everything. So these reports should be the easiest to validate is what Rajeshwari had mentioned. They're essentially, yeah, using just drawing data from the exact same source. So if there are any low hanging fruit like this, just get that done with initially, I would say. So you can just check that off the list and move on to more complicated items. And try to pick, try to, like, these deadlines are hard deadlines that we have communicated to the client. So focus on, like, these should be our guiding metric. If you are encountering any issues and being able to see data for the reports with the nearest deadlines, then that should be our first, that should be the first item that you should flag on the group.

**Speaker 1** · 00:07:26

If that is the case, we can start with 16th September reports first, then 18th, right?

**Me** · 00:07:33

Absolutely, yeah.

**Speaker 1** · 00:07:35

If it is not assigned to also, we can start that 16th.

**Me** · 00:07:39

You start with those. If, yeah, these assignments you can distribute internally, that's up to you. But start with those.

**Speaker 2** · 00:07:47

Sure.

**Me** · 00:07:49

If you are encountering any issues with being able to see data, just don't wait for them to get populated. If you are able to work on other reports for which data is available, you should do that. Oh, sorry.

**Speaker 2** · 00:08:03

Sorry, Koshik. Where do we have to like keep this evidence drop links?

**Me** · 00:08:08

So, I'll just create a folder, SharePoint folder.

**Speaker 4** · 00:08:08

Okay.

**Me** · 00:08:12

Maybe you can just upload your documents into that.

**Speaker 4** · 00:08:14

Yeah.

**Me** · 00:08:14

So, I would prefer if we just created one document per report, so that we just keep it separate.

**Speaker 4** · 00:08:15

Yeah.

**Me** · 00:08:20

In the future, if we want, like, whenever we finalize the structured format, we can just put everything into Clawed and ask it to make it.

**Speaker 4** · 00:08:20

Yeah. Yes. Yes. Yes. Got it. Got it. Makes sense. Sure.

**Me** · 00:08:31

Okay. So, I'm thinking let's just have quick 10-15 minute check-ins once in the morning, once in the evening for this week at least, because we are running on very tight deadlines.

**Speaker 5** · 00:08:39

Yeah.

**Me** · 00:08:40

So, what time would work for you guys? Is 10 a.m. okay in the morning?

**Speaker 5** · 00:08:47

That works.

**Me** · 00:08:48

So, I'll have a meeting at 10 a.m. And the evening is a little later, okay? Maybe around 9 p.m.?

**Speaker 4** · 00:08:55

9.30 I will be having calls.

**Speaker 2** · 00:08:58

8.30 we can do, because 9.30 I have my standard calls.

**Me** · 00:08:59

Yeah, even 9.30 I... Oh, wait. 9, I have a call.

**Speaker 1** · 00:09:09

Yeah, for me, it's fine.

**Me** · 00:09:09

Okay, sure. Arun, is 8.30 fine? Okay. Then I'll just schedule these calls. Then I will create the folder also for you to upload the documents. And just get started. Any issues that you're facing, please raise them on the ground. Like, we have to be able to meet these deadlines.

**Speaker 6** · 00:09:32

Thank you so much. Bye.

**Me** · 00:09:32

Okay.

