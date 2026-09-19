---
title: "Ad-Hoc Call with Atul Kala"
recorded: "2026-09-09 10:54:27"
context: "Kaushik, Atul"
watch_for: "Action items for Kaushik and Atul"
duration_seconds: 518
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 2 min of speech
  - "Speaker 2": "?"  # 8 min of speech
  - "Speaker 1": "?"  # 19 sec of speech
status: summarized
speaker_evidence:
  - "Speaker 1": "Atul is mentioned in the context provided by Kaushik."
---

## Transcript

**Speaker 1** · 00:00:00

Hello, hi, Dashit. Yes, please tell me.

**Me** · 00:00:00

Hey, hi. Good morning. Hey, so for the DDFPRV table, basically there are two columns with special characters that are being converged into one column, right? Because 5tran is not picking up the special characters.

**Speaker 2** · 00:00:07

Yeah. No, no, no, what Fyftran is doing, right? We have these two columns. So what Fyftran can do, it replaces special characters with the underscore. So when it is bringing, it is only bringing one column. It is telling me we have duplicate columns and it can't bring.

**Me** · 00:00:38

Yeah, so whatever issues that you've raised with 5tran, is there no provision for us to add an edge case when we are doing the ingestion part?

**Speaker 2** · 00:00:47

Yeah, so there is this option available and that will overwrite the Fyftran capability to replace special characters with the underscore. But for that, we need to create a new connector itself. We can't modify the existing connector. So for especially for the staple, we need to

**Me** · 00:01:05

Okay, okay.

**Speaker 2** · 00:01:08

create a new connector. So I need to discuss this with Ravi and Rishabh and I have to create the new connector. So I'm not getting time to discuss all these things because already like one family. So time wise, I think it should not take like more than one hour and it will take

**Me** · 00:01:26

How much time will it take to create the new connector if they are okay with it?

**Speaker 2** · 00:01:37

only 30, 40 minutes. But then first I need to do TORO analysis if we are not missing on something. Creating a connector is easy, but then doing that base analysis, right? What if the column that, what if the column already exists? Like we have two columns with the underscore thing. So that's where like I want to use help whenever he's saying data is not matching or something is wrong. I need evidence. So as of now, like I'm getting told that data is not matching that the base and the analysis I have to perform by myself. What is not matching? How much count is extra? Why it is extra? So that's why like if you see yesterday also like I have some screenshots for which it simply was telling it count is not magic or data is not matching. But when I'm running those group by statements or when I'm checking at the right time, the data is there. Yeah, yeah, yeah, yeah.

**Me** · 00:02:39

Yeah, yeah. So see, he is testing like 150 odd tables. So most of them he is passing. Some of the tables where there is a row count mismatch or a column count mismatch, he's highlighting. But he is anyway doing secondary analysis as well. But for this particular table, there is a column count mismatch and I think, okay, I mean, obviously you will have to do a deeper check before you start fixing anything.

**Speaker 1** · 00:02:55

Yeah.

**Speaker 2** · 00:02:56

That issue is clear. Still, I'll end quickly. It's a defect, right? Yes. Yes. It's a defect

**Me** · 00:03:03

But I think the issue is clear only that those special characters are getting deplaced with underscores.

**Speaker 2** · 00:03:18

that needs to be fixed. And I need to. We have to fix. It's just that what I'm saying past also, like we must have faced the similar issue, right?

**Me** · 00:03:23

If you do it today, tomorrow, before we close for QA, before the 21st, it will have to be fixed. Anyway.

**Speaker 2** · 00:03:36

It's not the only table that has duplicate columns. So I want to understand from the team that how exactly they have solved this problem. Maybe they have solved it in some X, Y, Z manner. So I don't want to like directly jump into the solution. Solution I have already placed in my mind. This is the solution. This is the approach that I'll follow. But then I still need to consult with the team because in past I remember team facing the similar issue in the previous releases. So that, that, that, that, that thing I need to discuss with the Vicas and Rishabh, like how exactly they solved it. Maybe they have a much better idea than creating, because creating a new connector only for one table.

**Me** · 00:04:19

Okay.

**Speaker 2** · 00:04:23

We should like do it only when it is the, when it is the, when it is our last resort. So discuss for our time, DJ. Sorry. Performance concern. Yeah. You can tell, you can say like this, because, uh, whenever we create a new connector, right? Uh, uh, uh, it will, uh, it will, uh, it will still read all the files in the backend, like data logs, uh, data log, uh, it will read for all the tables, you know? So it will not read the data log only for one table. So all those things, uh, that's what like I need to discuss with, uh, Rishabh and, uh, Vicas, uh, what, what will be the, uh, best approach? Because, uh, if you are creating a new connector, then what if, uh, it is, uh, uh, making conflicts with, uh, the existing connectors. So, and moreover, it will be a production thing, right?

**Me** · 00:05:15

Okay.

**Speaker 2** · 00:05:18

So you need to be cautious before, uh, implementing anything new in the production. So that's why I like, uh, this thing I have not closed yet.

**Me** · 00:05:24

Makes sense.

**Speaker 2** · 00:05:27

This, uh, D, uh, P, P, V, V, V, V, Hanna?

**Me** · 00:05:31

Right. And what is the issue with F5548020, that is, is that data integrity issue, sir?

**Speaker 2** · 00:05:38

No, I don't think so. It will be a data integrity issue. I think we are checking the wrong columns. If you see the column names, right? It is J, T, M, E. Those are timestamp columns or time columns. So if you will give it to the cloud and we will ask, we will give some sample data. It will just tell us that, uh, uh, uh, that, uh, it is having, uh, 8th of September. Maybe, uh, uh, it is, uh, this thing data refresh issue in the DB2 side, the value, uh, the value will be one 26, 527 like this, right? But then the corresponding, uh, uh, uh, value for it, the business value, uh, for it will be 8th of September. Whereas in the snowflake side, value will be one, one less than, uh, suppose in the DB2 side, it is 99. And in the snowflake side, it will be 98, but that 98 will correspond to 7th, uh, 8th of September. Like instead of 9th of September. Right? So it's, it's not, uh, the quantity columns. It's not the, uh, this thing quantity or some, uh, random columns. These are timestamp columns, I guess, because if you read the names, right? It is TME, PJ, PJ, TME, PJ, DJ, you know? Am I, am I able to make sense for AR? I think my, my, my, my fall started.

**Me** · 00:06:52

Yeah. Yeah.

**Speaker 2** · 00:06:54

Uh, I have to join that fall. But at a high, so what I told, uh, this guy, uh, what I told, uh, Supriyo. Since we have already done renaming for this column at the silver layer. So just, uh, take the reference. Like if you, if he's not able to understand, uh, the corresponding, uh, this thing, right? Uh, uh, the name, the business column name. So he can refer to the silver mapping, the silver view, or he can directly give it to the cloud and get the, uh, this thing. Get the name for, for those columns. You know?

**Me** · 00:07:27

Okay.

**Speaker 2** · 00:07:27

And, uh, if he sees any issues at a particular role level, like this minimum and a maximum, right? Uh, we have to like, uh, deep dive a little bit more, you know, maybe add up.

**Me** · 00:07:37

Okay. I think this F55 for 8020, I will check with Supriyo. I'll try to close this out with him.

**Unattributed** · 00:07:41

Yeah. Yeah.

**Me** · 00:07:43

The other one, just try to get some time and either discuss with Ravi, Rishab and Vikas.

**Unattributed** · 00:07:43

Yeah. That's what I want to say. Yeah.

**Me** · 00:07:46

Like, at least with Ravi, just try to drop a message on the silver view unit testing validation group, just outlining the issue and whatever input you need from him.

**Unattributed** · 00:07:46

Yeah. I need to. Yeah. Yeah. I need to. Yeah. Whatever I'll tell. Right. I'll tell in the group only. Yeah. Yeah.

**Me** · 00:07:53

Because everybody's occupied, right?

**Unattributed** · 00:07:53

Yeah.

**Speaker 2** · 00:07:54

yeah that's what i'm saying i need to yeah whatever i'll tell right i'll tell in my group only

**Me** · 00:07:55

You might not get time for a call. So, just try to drop an email or a message and get clear clarifications over that. Okay.

**Speaker 2** · 00:08:09

yeah that's yeah so everyone is telling me we have to close it to close it out by today

**Me** · 00:08:10

Because Ajraat, we have a meeting with the QA head from Anshura and he will be looking at this. I know. I know. But just, you're saying since it's only a 30-40 minute job, if you can do it in the background

**Speaker 1** · 00:08:24

okay i need to join another call i'll call all this started so thank you

**Me** · 00:08:26

or if you can get your doubts resolved, just try to do it.

