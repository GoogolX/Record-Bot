---
title: "Call with Ravi to Clarify Open Questions before Call with Tommy Want - 9 Sep 2026"
recorded: "2026-09-09 19:18:56"
context: "Kaushik, Ravi"
watch_for: "All the questions I asked and Ravi's answers to them, in great detail without summarising or compressing"
duration_seconds: 618
model: "ggml-large-v3-turbo-q5_0.bin"
language: "en"
diarized: yes
own_mic_track: yes
speakers:
  - "Me": "Kaushik"  # 3 min of speech
  - "Speaker 1": "?"  # 9 min of speech
status: summarized
speaker_evidence:
  - "Speaker 1": "Provides detailed explanations and answers questions about data transformations and QA processes."
---

## Transcript

**Speaker 1** · 00:00:00

Hey, Goshik. Yep. Yes, tell me yet.

**Me** · 00:00:00

Hello. Yes. So, from what I understand for the silver checks, what we are just doing, what we're doing is row count checks, column count checks, and just audit column checks. We are not doing any data count checks. So, what I did not understand is, if bronze to silver is supposed to be a cleanup step, where we deduplicate and rename columns, etc, then how will the

**Speaker 1** · 00:00:30

Yeah, from Bronze to Silver, we are just renaming and adding those other, meaning taking care

**Me** · 00:00:30

row count match? Or are we not doing any deluplication at all? So, just wanted to understand what transformations we're doing from bronze to silver.

**Speaker 1** · 00:00:46

of the audit columns and all that. We are not doing any other transformation per se. It is just a view basically. Silver layer is always just a view. From Silver to Gold.

**Me** · 00:01:00

Okay. Okay. So, any cleanup transformations are done from silver to gold, is it? Okay. Okay. Okay. Maybe another question I had is, in data compi, I think I noticed that we had to specify our tolerance value for numeric checks. So, in case Tommy asks, I mean, I'm not sure if he will really get into this, but I just wanted to be aware of what that value is.

**Speaker 1** · 00:01:21

So, that we have to check. So, can you just ping Mohit and ask him. So, did Supriya not

**Me** · 00:01:31

Yeah. Yeah. Sure. Sure.

**Speaker 1** · 00:01:36

know? I think Supriya has not done it for Gold. Okay. Okay. Do another thing, Kaushik. Just

**Me** · 00:01:38

Yeah. Yeah. That's right.

**Speaker 1** · 00:01:46

connect Supriya and Arun and ask Arun to just get the whole data comp utility, everything installed and set up. Okay. So, in case we need him also to run it, we should be able to get data. Which one? Okay. Yeah. Yeah. Yeah. Yeah. Yeah. Yeah. Yeah. Yeah. Yeah. Yeah.

**Me** · 00:02:07

I think another question I had is, Tommy will ask why we have done QA for these tables, right? So, are these tables part of some specific datasets that we have prioritized? Is that the ones that we have done QA for? So, there are around 120 silver tables and 45 gold tables, right? So, all of these are PCS, finance, time and labor, and TMS.

**Speaker 1** · 00:02:35

So, these are all tables in scope. Okay. And he always gets confused. Okay. So, let me also give you some background. So, when we say Bronze tables, right? It is basically the tables we are taking from the source systems and ingesting. Right? Using Phytran. Okay. Now, many of these. So, during R1 and R2, we were trying to even wrap up the complete ingestion activity for the entire migration program. Okay. So, at that point, not just the tables that we need for R1 and R2, we also completed the ingestion for a lot of the additional source tables as well. Because they were coming from, all were coming from the same source like JD and AS400. Okay. It was easy for us to just pull that in. Okay. Because in Phytran, you have a connector. You just need to select the tables you need to pull in. So, we just pulled all of them in and we had tested it also as part of R1 and R2. Okay. So, now when R3 started, okay, we identified that there's this 120 odd tables that we need. Okay. And that is the scope of all the source tables that we need to bring in. Okay. So, initially, we had 120 bronze tables and 120 odd silver tables, whatever that number was. Okay. Now, when we reviewed this with Heidi, she said, okay, you have already completed this and you have already completed for JD and legacy. So, why are you again redoing it? There's no need for us to redo this because this is already in production. Okay. So, that's where bronze count went down to 36 or 44. Right. But though we had brought it into the bronze layer, we had not created the silver layer for those tables during R1 and R2. Okay. So, that's why bronze is 36, 34, 44 rather, and silver is 124. That's why there's a difference. Yeah. But

**Me** · 00:04:51

Understood.

**Speaker 1** · 00:04:52

in terms of testing, all the bronze and silver is now covered. Essentially. Yeah. Yeah. So, I just

**Me** · 00:04:56

Okay. Got it.

**Speaker 1** · 00:05:00

wanted because last time I gave him the same background. I'm sure he will again, maybe ask

**Me** · 00:05:06

Yeah.

**Speaker 1** · 00:05:06

why there's a difference. Okay.

**Me** · 00:05:06

That makes sense.

**Speaker 1** · 00:05:09

Uh-huh.

**Me** · 00:05:09

One more question I had is, so some of the tables, some of the silver tables, we are comparing against DWH Prod instead of Bronze.

**Speaker 1** · 00:05:14

Uh-huh.

**Me** · 00:05:17

And this Suprio said is because they are filtered views that exist on Prod and in Bronze, we might have directly picked up from the source systems, not from the DWH Prod's environment.

**Speaker 1** · 00:05:30

Correct.

**Me** · 00:05:33

So, is there any list of cases such as these or is it just identified case-to-case?

**Speaker 1** · 00:05:40

No, this is identified case-to-case.

**Me** · 00:05:44

Okay, maybe one last question. This is a bit of a stupid question. Maybe I should have asked this a long time ago, but if Gold is reconciled radically against DB2, that I understand that we are doing because both of these layers are what are going to be

**Speaker 1** · 00:06:00

No, so, correct.

**Me** · 00:06:03

feeding into the reports and that is what our client is also interested in ultimately. But if this is the case, then why are we building the Bronze and Silver layers in the first place? Is it for like future cases where there might be a need?

**Speaker 1** · 00:06:21

So see, bronze is basically, I have, say, three, four sources. Okay, Seridian, TMS, AS400, JD. Okay, so in those sources, I have some actual physical tables like any application, right? So when we build an application on ERP, they will have their own tables, right? So I will bring those as it is into my bronze layer. Okay, then I will, usually what happens in the silver layer is you do some level of, as you were asking earlier, right? Some data quality checks and deduplication, some cleansing and all that. And you could create the silver layer. Okay, in our case, we have not done that. We have just kept it as it is. Okay. Then what happens is that you, you know, you bring together these multiple tables together to form the dimensions and facts. So when you say a sales order invoice dim or a sales order invoice fact, it is not being built only through one table. It is being built through joining of multiple tables. In some cases, the complex ones, there are 10, 12 different tables which are coming together. Correct.

**Me** · 00:07:35

Right.

**Speaker 1** · 00:07:35

Correct.

**Me** · 00:07:35

So, this is business level aggregation that we do with the Gold layer.

**Speaker 1** · 00:07:36

Correct. Correct. Correct. So basically, every day the source is getting updated in bronze layer and then the gold is accordingly getting refreshed on top of it. This is the transformation rules, everything we have on top of it. So just bringing the gold directly will not do. Okay. We will also need to maintain the source also because every, that is kind of the source of truth to speak because that is the actual transactional data.

**Me** · 00:08:01

Right.

**Speaker 1** · 00:08:07

Okay. And the gold is just a business layer basically.

**Me** · 00:08:13

No, I'm just thinking if he asks if there is any, like, what is the proof that our Gold layer is built from Bronze and Silver? Like, is it just in faith? Like, we are not doing any recon checks against Silver or Bronze, right? We are just comparing against DP2.

**Speaker 1** · 00:08:25

No, no, no. Yeah. Yeah. Yeah. Yeah.

**Me** · 00:08:30

That's fine.

**Speaker 1** · 00:08:30

That is, that is okay. Even see, even for them, the main piece is the compatibility view because on top of gold, we have this compatibility view. Okay. So gold may still have some minor differences here and there with the DB2 layer. Okay. In case we have modeled it differently, even though I would say 90% it is modeled the same as DB2. Okay. But in case we have made some changes in how it is being captured and everything, there might be some differences.

**Me** · 00:08:56

Right.

**Speaker 1** · 00:09:02

But in compatibility layer, what we are doing is we are creating the views as, you know, as similar to DB2 as possible. Okay. Okay. That is the reason is because we want to ensure the reports are not impacted at all. Okay. The reports when they hit the compatibility view, they get the same columns and data as they are getting in DB2. Okay.

**Me** · 00:09:28

Makes sense. Yeah. No, I was just thinking like if I were the client, maybe I would also want some, I don't know, assurance

**Speaker 1** · 00:09:29

Okay.

**Me** · 00:09:35

or proof that our Gold layer is getting its data from the Bronze and Silver layers. And so, so, I mean, maybe for the, this, the sake of this call, it's fine.

**Unattributed** · 00:09:42

Yeah.

**Speaker 1** · 00:09:43

Yeah. Yeah.

**Me** · 00:09:44

Later on, we can look into something that captures that information as well.

**Speaker 1** · 00:09:45

Yeah. I mean, that is basically a code level check, right? Because the code will contain where it is pulling from. Yeah. Not sure if we can do that, but yeah, that is something they have to take it down the road.

**Me** · 00:10:06

No, I'll, I'll also think about this.

**Speaker 1** · 00:10:07

Yeah. Yeah.

**Me** · 00:10:08

Transition clarification.

**Speaker 1** · 00:10:09

No problem.

**Me** · 00:10:10

Cool. Thanks for being here.

**Speaker 1** · 00:10:12

Okay. Thank you.

