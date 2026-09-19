---
title: "Call with Rajeshwari and Arun to discuss VF Report Testing"
recorded: "2026-09-10 14:22:00"
context: "Kaushik, Rajeshwari, Arun"
watch_for: "Action items for each person, along with a comprehensive overview of what Rajeshwari explained (complete with a list of technical jargon in the form of a glossary)"
duration_seconds: 1488
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 5 min of speech
  - "Speaker 1": "?"  # 20 min of speech
  - "Speaker 3": "?"  # 50 sec of speech
  - "Speaker 2": "?"  # 41 sec of speech
status: summarized
speaker_evidence:
  - "Speaker 1": "Described the testing process for various types of reports and provided detailed explanations about technical aspects."
---

## Transcript

**Speaker 1** · 00:00:00

CSV comparison tool. Using that, we used to download the reports in a CSV format and then compare it. Yeah. Okay. Okay. Yeah. Yeah. Let me share my screen. Yeah. I think this is

**Me** · 00:00:06

compare it. Okay. Okay. Maybe I'll have a better idea of what's happening once you do the walkthrough. So let us start with that. And following that, we'll also narrow down the testing parameters. And once that is done, I will also check the list of reports and share with the both of you the sheet that I've created. I think since you are going on leave tomorrow Rajeshwari, Arun, there are, as of my knowledge, seven to eight reports that need to be tested and reviewed. So these, there is no blocker as such. So these we are aiming to complete by this weekend. So you have today and tomorrow to finish these. So just make sure that you have everything that you need from Rajeshwari because you will be unavailable tomorrow. Monday is anyway a holiday. So yeah. Yeah. Sure. Okay. So can we do that

**Speaker 1** · 00:01:10

the sheet which you are aware of already, Kashik. This is the priority. Yeah. Goal tables

**Me** · 00:01:19

focusing on purely priority one report. So this sheet we can share with you. And the other sheet, report underscore table underscore mapping, it has all the mappings from the reports to the

**Speaker 1** · 00:01:36

or it could be a view also. And you are directly hitting to our TMS VFDWH tables, which are used in our SQL based reports. Okay. To start with, we have totally 62 reports and out of which this red highlighted ones are kind of a personal object reports or some typo in the report name. We are unable to find those reports in the microstrategy environment. So I have sent out an email to Lakshmi to confirm about these reports. If we ignore that, we have two other reports. For PCS, we got a confirmation and we have got an access. For the rest of the other reports, we are going to test based on the priority. For this, what I have done is like, I think somewhere we have like repointing completed or something. We can start that is what I

**Me** · 00:02:36

you prioritize the ones that are not financed. Because finance card, UAT starts on October 21st, if I'm not wrong. So everything else should definitely be done. Finance, even if there is a one,

**Speaker 1** · 00:02:57

believe. Repointing status. Here also we have whatever is like completed as part of release one and release two. Right? We have a few reports which we can test on. And when coming to reports, right? There are different types of reports which we will be testing. Okay. Let me show you. One would be a dashboard. One would be a queue. And the other one would be a grid report. A basic grid report. I'll show you. This is our project, which you can take as your source of truth. Let me pick any one report and show you. Sure. Let me pick this open purchase contract details. I'm not sure which kind of report it is. I'll just go here, type in the report name and get exactly looks like it's a dashboard. Open purchase contract details. If you go to this. If you go to this. If you go to this particular report, if you see these kinds of icons, this means it's a dashboard or a dossier, we call it as. Let me open this report and this report. I don't know what all is involved in this particular report, right? To check this, what I do usually, I go here as we have a table mapping. I just select that report. It has a report called this open purchase contract, which involves these three tables in that. And these are already covered as part of release one and two. So we are good to test this report. Okay. And some of the reports. Yeah, this is one of the reporting. What you see here, it is. We are getting some data. Looks like it is a grid report. If it is not a grid report, we have to publish the queue. If there is something new because cube is nothing but it's kind of a cache. Until unless you republish it next time, the old data will be stored over there. This is how we do that. Let me show the same report in production. Oh, sorry. In our Snowflake dev environment. And this is our Snowflake dev production.

**Speaker 2** · 00:05:18

Okay. Now we are comparing with prod with the Snowflake, right?

**Speaker 1** · 00:05:22

Earlier, we used to do that. We can come up with a plan how to test in this release because if it is a SIM. Sorry, I think it got stopped. Screen share. Let me re-share it. Yeah.

**Me** · 00:05:37

Also, I don't ensure that whatever reports you're testing, you download both versions, both the db2 and snowflake versions to your local system before you start testing. Because if there is any refresh mismatch,

**Speaker 1** · 00:05:50

It's the same report on the same path. Oil trading report. Yeah.

**Me** · 00:05:50

then whatever is on the environment itself might not match when you're checking.

**Speaker 1** · 00:06:07

By default, as this particular report runs for ninth, right? This is the default selection which we have given. I doubt there would be data, anything present for this particular report as we are not running any incremental run. Looks like there is some syntax issue which I have to look into it. Where care format, I will check that. If there is, let me check if there is any report which I can pick it up.

**Me** · 00:06:33

So, Rajeshwari, based on your experience, how much time does it take to check each report

**Speaker 1** · 00:06:35

If it is a simple grid report, what we used to do is we used to compare like row by row using the CSV comparison tool. It was taking around one to two hours. I can say there are no challenges if it is a simple report.

**Speaker 2** · 00:07:06

And also Kaushik, we need that tool which Ravi has, right?

**Speaker 1** · 00:07:18

Yeah, row by row data.

**Me** · 00:07:25

I think you can use. But if there is any specific tool, then okay, I'll try reaching out to double.

**Speaker 1** · 00:07:31

No, no, no, no, no. It was something which he had done locally. He had shared with me, but the latest version was not working. Whatever I have, I'll share that with you, Varun. Sure. Let it execute it in one minute. I'm checking in the wrong place. That's why this project has to be QA. Sorry, I mentioned it as dev, right? It has to be a QA project. And let me go back to the same report which open purchase, contract details. Have I opened same report? Yeah. Yes. This is what we have. And this is the report. And here also we have the same report. What do we do? Usually we compare row by row. What is that? As we have here a subtotal enumerable drive, we can compare that subtotal. 154.77. Same thing with a negative value also we have. What we used to do is we just used to export data. Data is nothing but it's a CSV format. It will download in CSV format, both from our prod environment and from our...

**Speaker 2** · 00:09:14

In the prod also, it will be same, this report only, it will be there.

**Speaker 1** · 00:09:18

Yes. Same report, same name, structure, everything has to be done if there is no modification. If there is some modification done by the customer to some of the reports, means we have to re-migrate that particular report. We download this and we used to compare. If it is kind of a graph-based report and all, we used to compare it graph by graph like that by converting into a grid. That's what we used to do in the earlier releases. This is the dashboard example. This is a very simple. Base reports, if it is a simple report, as I said, one to two ads, we used to take on an average Kaushik here. It is a very simple report and it involves only one report, right? So, we used to publish the cube, check the cube count and then come to dashboard and validate those reports. If we are good with our base reports, data sets or cubes, then our dashboard also will be good in that case.

**Me** · 00:10:20

in that case. Okay. Okay. So maybe another note from me, whatever tests you guys are doing. I think previously you were posting screenshots of the results in the tracker itself, right? So this time...

**Speaker 1** · 00:10:33

Just for my reference, I was pasting it out so that I don't lose it, but I have to change. So, Ravi said he'll give some space where we can have all our evidences.

**Me** · 00:10:45

So just maybe have all evidence slash information results, everything in like a word doc, one word doc per report, but I'll also think about this and see what is the best way to replicate this approach. We can

**Speaker 1** · 00:10:53

Yeah, if there is any better approach, we can implement in this release 3. Yeah. These all were dossiers. I want to show if there is any grid report. Let me pick up if there is any grid report. Reals, orders. Let me check if it is a grid report. Yeah, if you see this icon, right? It says it's a grid report.

**Speaker 2** · 00:11:46

Okay. There are two reports, right? On this grid, on this dashboard.

**Speaker 1** · 00:11:52

Within dashboard, we can have cubes also. I'll show you cubes also. In production, this is having some issue. We have to check why in prod only this is having issue.

**Speaker 2** · 00:12:10

I need to report this.

**Speaker 1** · 00:12:13

In prod only, if it is not opening, we can check with the customer because most of the reports here in oil trading, it is built by them only. Okay. Let me show you with whatever I have done in execution. These are the top five highly used reports. So let me pick this node. It says this one only let me pick and show you. Don't cube, right? This report involves a cube. This is the report. Just click the report name. Don't click on shortcuts. Click on the direct reports. And it involves a custom query. It says custom query. Here, you can edit this custom query and check from where exactly it is coming. Kaushik, to see, to the other point, right? You were talking about bronze, silver, all these layers, right? This is a SQL-based cube, which directly comes from prod ASP DB. Here, it doesn't involve anything of our bronze, silver, or gold tables. It's directly a source table in this particular report, which it is involving. And we are not doing any modification. We will just run these reports, capture the results. It is exactly matching with production because we are directly hitting the same DB in both the pieces. This is one type of cube. It's a SQL-based cube. I showed you a dashboard. The other one was grid. And this is a SQL-based cube. How does the normal cube look like this? This is your cube, which appears in the cube icon only. If you see here in this list, directly, you won't have any cube reports because cube reports can't be executed independently like grid report. Always, it has to be used within one or the other dashboards.

**Speaker 2** · 00:14:18

Let me see if I have any dashboard.

**Speaker 1** · 00:14:23

I think I'll let me show you some dashboard, which was part of release one and two, okay? So that I can cover that also, how the dashboard looks. This is our OFI report, which is one of the highly used reports in our release two.

**Me** · 00:14:54

the paths. The paths to all of these reports, is there any repository for Arun to navigate, to use to

**Speaker 1** · 00:14:54

This is it. See, customers have not given any particular path for here as the names are unique. That's what I told. Don't click on any shortcuts. When we searched for like that OFI report or something, right? Let me pick that open orders. Was this report which I picked open order in details or open sales order or something I picked up, right? If we search this in whole project, just mention it as exact. It will give you only one appearance of that particular report. Yes, names are correct. Might be, it might have an extra space in the end. We can remove it and give the exact name. Let me show if there is any other report. This is a grid report and this is also exactly. If I don't give exactly and give contains, right? You will find multiple other reports like purchase ways. It will give all possible names over here. So, always I try to give exactly so that we get only one. If there are more than one report, by looking at the location, usually we can identify. Looks like this is an oil trading report and it's under oil trading. We can navigate to this particular report and as in when we test the reports, we can fill in the path also. This is the report here. And when it comes to this dashboard, this is the dashboard. One of the complex dashboard, I can say here you see there are some selectors, grids. These are also called as selectors and there could be some graphs also in some of the reports. These are some of the KPIs involved and this is also a grid along with kind of a selectors and all. What does this have is this involves these many cubes and reports in that.

**Speaker 3** · 00:17:02

Okay.

**Speaker 1** · 00:17:02

Okay. The first, these all are IQs, potential shortage 14 days, transfer 14 days. These are cubes. This can never be tested independently or they can be used. I mean, independently, we can't use this. Always it is dependent on a dashboard. So cube always will be present within the dashboard itself.

**Speaker 2** · 00:17:21

The cubes like directly you are taking data from source, right?

**Speaker 1** · 00:17:25

Not source. It's always it will be on our goal table. It is like grid report only.

**Speaker 2** · 00:17:30

Okay.

**Speaker 1** · 00:17:31

Difference between grid report and cube is grid always hits the database whenever you execute that grid report.

**Speaker 2** · 00:17:37

Okay.

**Speaker 1** · 00:17:38

It is cube means usually it will be heavily loaded cube. It will come from a cache.

**Speaker 2** · 00:17:43

Okay.

**Speaker 1** · 00:17:44

Until unless you refresh that cube, it will be hitting the cache and you will getting the data. Okay. That's the main difference. This is the dashboard here. As I said, we will be individually downloading the grids and then testing those reports. And for other testing, what I used to do is I used to enable the total that total are we getting the same total or not. That is one check I used to do if we are getting the totals properly or not. If it is a new report or you can add a sheet but don't save anything, we will have something called as row count to check. If it is one by one, if you are testing a cube, right? Pull in the date. Are you getting the same set of date in the other cube also or not? One by one individual testing I used to do like this. If it is complete grid report, pull everything. Whatever you have, I think you can ignore. These are the derived ones with different effects icon, right? Those are all derived ones. For time being, we can ignore that. Just pull everything, whatever you have. You can download individual cube reports and compare it along with your prod report. Kaushik, any idea by when we will get data?

**Me** · 00:19:09

Um, so for at least the R1, R2 reports, the data should be available, right?

**Speaker 1** · 00:19:16

No, Kaushik, I didn't see your data. I have mentioned here with whatever, like I was executing these reports for checking the validation of syntaxes and all. I have just made a note that there is no issue in that particular report and there is no data also.

**Me** · 00:19:36

Okay. Hmm. So, uh, this is just that there's no data in the QA Snowflake environment, right?

**Speaker 1** · 00:19:45

Yeah, that's what I have informed Ravi also. He said they'll make sure they'll get the data. I think these are some of the reports which I have tried to make sure there is no error, nothing, they're executing in the cube.

**Me** · 00:19:51

Okay. Okay. I'll also, I'll also have to check with him.

**Speaker 1** · 00:20:02

Once we get any data right, we can pick up these reports and start testing them.

**Me** · 00:20:08

Okay. Okay. Okay. Then, uh, to the sheet, can you just add a column with the owner name also? So we can just distribute them amongst, uh, you and Arun. I think Siley will also be helping. Yeah. Yeah. So just, uh, three of you, we can distribute them. Yeah. Yes. And I'll just try to

**Speaker 3** · 00:20:23

Yeah, yeah, yes.

**Speaker 1** · 00:20:29

I think this roughly I have made this sheet. We can make it in a proper format. Yeah. If you have any questions, I'll be there anytime you can reach out to me. I think Arun, anyhow, he sits here. I can work with him closely.

**Me** · 00:20:54

so without the data, we can't start testing. Are there no reports that have data?

**Speaker 1** · 00:20:59

These reports are SQL based which are using Friday SP, right? One, two, three, four, four reports. We can pick it up. It will match exactly with the production and we can capture the screenshot.

**Me** · 00:21:10

screenshot. Okay. So the result that we want to communicate, basically that there is no difference in the DB2 and Snowflake reports. Is there no better way to do it than, uh, just showing a screenshot? Like if we're doing this, if we're using like a CSV row by row comparison tool, then some sort of summary should help, right? At least for the grid based reports.

**Speaker 1** · 00:21:36

I think Ravi has the older reports. Let me check with him. What was the format the QV team had used earlier?

**Me** · 00:21:53

list of all the different types of reports that exist? I'll try to think of the best format.

**Speaker 1** · 00:21:57

Yeah, I'll send you that. I'll ping in the same group chat here and I'll give you the reveals.

**Me** · 00:22:04

Yeah. Yeah. Okay. So in at least these four or five reports, then Arun, I think we can get started.

**Speaker 1** · 00:22:09

Yeah, these.

**Me** · 00:22:11

What I would say is, uh, yeah, take today to at least, uh, try to understand how much time each one is taking and, uh, if there are 50 odd reports and we have three people working on the

**Speaker 3** · 00:22:21

Sure, sure.

**Me** · 00:22:26

same and we should also take in to factor the number of days that we have left before the 21st and see if, uh, there are any risks to us able to meet our deadlines. So to do that, just try to spend some time and understand how much time it is taking so that we, our estimate is more realistic. So we

**Speaker 1** · 00:22:50

For today, I think you can pick any one report and start it.

**Speaker 3** · 00:22:54

Sure, sure.

**Me** · 00:22:57

then, uh, just try to pick as many as possible and just close it off. Okay.

**Speaker 2** · 00:23:02

Okay, question. And one more thing, I'm going to ping Ravi asking about like old reporting documents, like how they were doing and so I didn't get any response from him.

**Me** · 00:23:14

So any QA, any, any QA related, uh, communication, anything that you need from Ravi or anybody,

**Speaker 1** · 00:23:14

He might say.

**Speaker 3** · 00:23:19

Sure, sure.

**Me** · 00:23:20

just drop a message on this group itself. Sure. Sure. So we can keep all communication here so that I'm

**Speaker 3** · 00:23:23

Okay.

**Me** · 00:23:25

also aware of what's going on. Yeah. I'll also, I'll add Sally also. If she's in the office with you,

**Speaker 3** · 00:23:26

Okay, question. Yeah.

**Speaker 1** · 00:23:31

Yeah. No, she sits in a different office.

**Me** · 00:23:38

Right. Then, uh, maybe Rajeshwari, can you just connect with her once?

**Speaker 3** · 00:23:42

Sure, I'll connect with her.

**Speaker 1** · 00:23:50

I'll connect with her and I'll walk her through what we're doing. Okay.

**Speaker 3** · 00:24:03

Okay, go for it. Yeah.

**Speaker 1** · 00:24:04

Yeah, thank you. Bye-bye.

