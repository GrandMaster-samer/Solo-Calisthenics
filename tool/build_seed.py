#!/usr/bin/env python3
"""One-off authoring helper that produced assets/data/exercises.json.

The JSON file is the source of truth and can be edited by hand; this script is kept
only as a compact way to author many exercises at once. Run: python3 tool/build_seed.py
Line format (| separated):
id|type(r=reps,h=hold)|sets|min|max|rest|stress W S E K B (0-3)|equipment|name en|name ar|cues en|cues ar|mistakes en|mistakes ar
Lists inside a field are separated by ';'. Exercises are listed easiest -> hardest inside each chain.
"""
import json, os

CHAINS = [
("push_up","push","Push-up","تمرين الضغط","""
wall_push_up|r|3|10|20|60|11100|wall|Wall Push-up|ضغط على الحائط|Hands at chest height, body in one line;Lower chest to the wall under control;Push away until arms are straight|اليدان بمستوى الصدر والجسم على خط واحد;أنزل صدرك نحو الحائط بتحكم;ادفع حتى تستقيم الذراعان|Hips sagging or piking;Elbows flaring straight out to the sides|هبوط أو رفع الوركين;فتح المرفقين للخارج تماماً
incline_push_up|r|3|8|15|75|21100|bench|Incline Push-up|ضغط مائل (اليدان مرتفعتان)|Hands on a bench or bar, shoulders over wrists;Keep ribs down and glutes tight;Chest touches the edge, then press|اليدان على مقعد أو بار والكتفان فوق الرسغين;اشدد البطن والمؤخرة;المس الحافة بصدرك ثم ادفع|Reaching with the chin instead of the chest;Half range of motion|مدّ الذقن بدلاً من الصدر;مدى حركي ناقص
knee_push_up|r|3|8|15|75|22101|floor|Knee Push-up|ضغط على الركبتين|Straight line from knees to head;Elbows about 45° from the body;Chest to the floor, full lockout|خط مستقيم من الركبتين إلى الرأس;المرفقان بزاوية ٤٥° تقريباً عن الجسم;الصدر إلى الأرض ثم مدّ كامل|Bending at the hips;Head dropping forward|الانثناء من الوركين;سقوط الرأس للأمام
push_up|r|3|8|12|90|22201|floor|Push-up|ضغط|Hands under shoulders, body rigid like a plank;Lower until chest is just above the floor;Push the floor away and spread the shoulder blades at the top|اليدان تحت الكتفين والجسم مشدود كاللوح;انزل حتى يقترب الصدر من الأرض;ادفع الأرض وباعد بين لوحي الكتف في الأعلى|Sagging lower back;Flared elbows at 90°|تقوّس أسفل الظهر;فتح المرفقين بزاوية ٩٠°
diamond_push_up|r|3|6|12|90|32301|floor|Diamond Push-up|ضغط الماسة|Hands together under the chest;Elbows brush the ribs on the way down;Lock out fully at the top|اليدان متقاربتان تحت الصدر;المرفقان يلامسان الأضلاع عند النزول;مدّ كامل في الأعلى|Hands too far forward;Shoulders shrugging to the ears|اليدان متقدمتان كثيراً;رفع الكتفين نحو الأذنين
decline_push_up|r|3|6|12|90|23201|bench|Decline Push-up|ضغط منحدر (القدمان مرتفعتان)|Feet on a bench, hands under shoulders;Keep the hips level with the shoulders;Lower with control, press explosively|القدمان على مقعد واليدان تحت الكتفين;حافظ على الوركين بمستوى الكتفين;انزل بتحكم وادفع بقوة|Hips sagging;Neck craning forward|هبوط الوركين;مدّ الرقبة للأمام
archer_push_up|r|3|4|8|120|33301|floor|Archer Push-up|ضغط الرامي|Wide hands, shift your weight to one arm;Keep the assisting arm straight;Alternate sides each rep or each set|يدان متباعدتان وانقل وزنك إلى ذراع واحدة;أبقِ الذراع المساعدة مستقيمة;بدّل الجانب كل عدة أو كل مجموعة|Twisting the hips;Bending the assisting arm|دوران الوركين;ثني الذراع المساعدة
one_arm_push_up|r|3|2|6|150|33302|floor|One-arm Push-up|ضغط بذراع واحدة|Feet wide, free hand behind the back;Keep shoulders square to the floor;Lower slowly, press without twisting|القدمان متباعدتان واليد الحرة خلف الظهر;أبقِ الكتفين موازيين للأرض;انزل ببطء وادفع دون دوران|Rotating the torso;Dropping into the bottom|دوران الجذع;السقوط في أسفل الحركة
"""),
("dip","push","Dip","تمرين المتوازي","""
bench_dip|r|3|8|15|75|22200|bench|Bench Dip|غطس على المقعد|Hands on the bench edge, fingers forward;Keep your back close to the bench;Lower until elbows reach about 90°|اليدان على حافة المقعد والأصابع للأمام;أبقِ ظهرك قريباً من المقعد;انزل حتى زاوية ٩٠° تقريباً للمرفقين|Going too deep with shoulders rolled forward;Hips drifting away from the bench|النزول العميق مع دوران الكتفين للأمام;ابتعاد الوركين عن المقعد
support_hold|h|3|15|40|75|21200|dip_bars|Support Hold|ثبات الارتكاز على المتوازي|Arms locked, shoulders pressed down;Body slightly hollow, legs together;Squeeze the bars|الذراعان ممدودتان والكتفان للأسفل;الجسم مجوّف قليلاً والساقان معاً;اقبض على البار بقوة|Shrugged shoulders;Bent elbows|رفع الكتفين;ثني المرفقين
negative_dip|r|3|3|6|120|23200|dip_bars|Negative Dip|غطس سلبي (نزول بطيء)|Start at the top in a support hold;Lower for 3 to 5 seconds;Step up to reset, do not press|ابدأ من الأعلى في وضع الارتكاز;انزل خلال ٣ إلى ٥ ثوانٍ;اصعد بقدميك ولا تدفع|Dropping fast at the bottom;Shoulders rising to the ears|السقوط السريع في الأسفل;ارتفاع الكتفين نحو الأذنين
dip|r|3|6|12|120|23200|dip_bars|Parallel Bar Dip|غطس على المتوازي|Lean slightly forward, elbows back;Lower until shoulders are just below elbows;Press to a full lockout|مِل قليلاً للأمام والمرفقان للخلف;انزل حتى يصبح الكتفان أسفل المرفقين قليلاً;ادفع حتى المدّ الكامل|Partial range;Swinging the legs|مدى ناقص;تأرجح الساقين
straight_bar_dip|r|3|5|10|120|33200|bar|Straight Bar Dip|غطس على البار المستقيم|Hands just outside the hips on top of the bar;Lean the chest over the bar as you lower;Press up and push the bar toward the hips|اليدان خارج الوركين فوق البار;أمِل صدرك فوق البار أثناء النزول;ادفع للأعلى ووجّه البار نحو الوركين|Elbows flaring wide;Not reaching chest to bar depth|فتح المرفقين;عدم الوصول بالصدر إلى البار
"""),
("hspu","push","Handstand Push-up","ضغط الوقوف على اليدين","""
pike_push_up|r|3|6|12|90|22201|floor|Pike Push-up|ضغط الرمح|Hips high, body in an inverted V;Head travels forward to form a triangle with the hands;Press back up through the shoulders|الوركان عالياً والجسم على شكل V مقلوب;الرأس يتقدم ليشكل مثلثاً مع اليدين;ادفع للأعلى من الكتفين|Elbows flaring out;Turning it into a regular push-up|فتح المرفقين;تحويله إلى ضغط عادي
elevated_pike_push_up|r|3|5|10|120|33201|bench|Elevated Pike Push-up|ضغط الرمح والقدمان مرتفعتان|Feet on a bench, hips stacked over shoulders;Lower the head in front of the hands;Press until arms lock out|القدمان على مقعد والوركان فوق الكتفين;أنزل الرأس أمام اليدين;ادفع حتى مدّ الذراعين|Hips dropping back;Short range of motion|رجوع الوركين للخلف;مدى حركي قصير
wall_hspu_negative|r|3|2|5|150|33302|wall|Wall Handstand Push-up Negative|نزول سلبي في ضغط الوقوف على الحائط|Kick up to the wall with locked arms;Lower for 4 to 6 seconds to the head;Come down safely and reset|اصعد إلى الحائط بذراعين ممدودتين;انزل خلال ٤ إلى ٦ ثوانٍ حتى الرأس;انزل بأمان ثم أعد|Collapsing onto the head;Arching hard through the lower back|الانهيار على الرأس;تقوّس شديد في أسفل الظهر
wall_hspu|r|3|3|8|150|33302|wall|Wall Handstand Push-up|ضغط الوقوف على اليدين على الحائط|Hands a hand-length from the wall;Lower the head gently to the floor in a tripod;Press hard and keep ribs tucked|اليدان على بعد كفّ من الحائط;أنزل الرأس بلطف على شكل مثلث;ادفع بقوة واشدد الأضلاع|Banana back;Bouncing off the head|ظهر مقوّس كالموزة;الارتداد على الرأس
freestanding_hspu|r|3|1|5|180|33302|floor|Freestanding Handstand Push-up|ضغط الوقوف على اليدين الحر|Start from a stable handstand;Lean slightly forward as you lower;Press back to balance over the hands|ابدأ من وقوف ثابت على اليدين;مِل قليلاً للأمام أثناء النزول;ادفع وعد إلى التوازن فوق اليدين|Losing the line at the bottom;Rushing the descent|فقدان الاستقامة في الأسفل;التسرع في النزول
"""),
("pull_up","pull","Pull-up","تمرين العقلة","""
dead_hang|h|3|15|45|60|12100|bar|Dead Hang|التعلق الحر|Full grip, thumbs around the bar;Let the body hang long, ribs down;Breathe calmly|قبضة كاملة والإبهام حول البار;دع الجسم يتدلى والأضلاع للأسفل;تنفس بهدوء|Swinging;Holding the breath|التأرجح;حبس النفس
scapular_pull_up|r|3|6|12|75|12100|bar|Scapular Pull-up|سحب لوحي الكتف|Hang with straight arms;Pull the shoulder blades down and together;Lower slowly back to a dead hang|تعلّق بذراعين مستقيمتين;اسحب لوحي الكتف للأسفل وللداخل;انزل ببطء إلى التعلق الحر|Bending the elbows;Shrugging instead of depressing|ثني المرفقين;رفع الكتفين بدل خفضهما
band_assisted_pull_up|r|3|5|10|90|12200|bar,band|Band-assisted Pull-up|عقلة بمساعدة المطاط|Loop the band over the bar, foot or knee in it;Pull the chest toward the bar;Lower under control to straight arms|ثبّت المطاط على البار وضع قدمك أو ركبتك فيه;اسحب صدرك نحو البار;انزل بتحكم حتى استقامة الذراعين|Bouncing off the band;Chin reaching without the chest|الارتداد على المطاط;مدّ الذقن دون الصدر
negative_pull_up|r|3|3|6|120|12300|bar|Negative Pull-up|عقلة سلبية (نزول بطيء)|Jump or step to chin over the bar;Lower for 4 to 6 seconds;Finish in a full dead hang|اقفز أو اصعد حتى تصبح الذقن فوق البار;انزل خلال ٤ إلى ٦ ثوانٍ;انتهِ بتعلق حر كامل|Dropping the last half;Skipping the full hang|السقوط في النصف الأخير;تجاهل التعلق الكامل
chin_up|r|3|4|10|120|12300|bar|Chin-up|عقلة بقبضة معكوسة|Palms facing you, shoulder width;Pull elbows down to the ribs;Chin clearly over the bar|الكفان باتجاهك بعرض الكتفين;اسحب المرفقين نحو الأضلاع;الذقن فوق البار بوضوح|Kicking the legs;Half reps at the bottom|ركل الساقين;عدّات ناقصة في الأسفل
pull_up|r|3|4|10|120|12200|bar|Pull-up|عقلة|Overhand grip slightly wider than shoulders;Start by pulling the shoulder blades down;Drive elbows to the hips, chin over the bar|قبضة علوية أوسع قليلاً من الكتفين;ابدأ بسحب لوحي الكتف للأسفل;ادفع المرفقين نحو الوركين والذقن فوق البار|Kipping;Not reaching full extension|التأرجح للمساعدة;عدم المدّ الكامل
l_sit_pull_up|r|3|3|8|150|12202|bar|L-sit Pull-up|عقلة بوضعية L|Lift straight legs to horizontal;Hold the L while pulling;Lower without dropping the legs|ارفع الساقين مستقيمتين حتى الأفق;حافظ على وضعية L أثناء السحب;انزل دون إسقاط الساقين|Legs dropping;Leaning far back|هبوط الساقين;الميل الشديد للخلف
archer_pull_up|r|3|2|6|150|13300|bar|Archer Pull-up|عقلة الرامي|Wide grip, pull toward one hand;Keep the other arm long;Alternate sides|قبضة واسعة واسحب نحو يد واحدة;أبقِ الذراع الأخرى ممدودة;بدّل الجانبين|Twisting the body;Bending the straight arm early|دوران الجسم;ثني الذراع الممدودة مبكراً
"""),
("row","pull","Bodyweight Row","السحب الأفقي","""
high_row|r|3|8|15|60|11100|low_bar|High Bar Row|سحب أفقي والبار مرتفع|Bar at chest height, lean back with straight body;Pull the chest to the bar;Squeeze the shoulder blades together|البار بمستوى الصدر ومِل للخلف بجسم مستقيم;اسحب صدرك إلى البار;اضغط لوحي الكتف معاً|Hips sagging;Pulling with the neck forward|هبوط الوركين;مدّ الرقبة للأمام
australian_row|r|3|6|12|90|11201|low_bar|Australian Row|السحب الأسترالي|Bar at hip height, heels on the floor;Body in one straight line;Pull the bar to the lower chest|البار بمستوى الورك والكعبان على الأرض;الجسم على خط مستقيم;اسحب البار إلى أسفل الصدر|Hips dropping;Shrugging the shoulders|هبوط الوركين;رفع الكتفين
elevated_row|r|3|6|12|90|12201|low_bar,bench|Feet-elevated Row|سحب أفقي والقدمان مرتفعتان|Feet on a bench, body horizontal;Pull until the chest touches the bar;Lower with straight arms each rep|القدمان على مقعد والجسم أفقي;اسحب حتى يلامس الصدر البار;انزل حتى استقامة الذراعين كل عدة|Short pulls;Hips piking|سحب قصير;رفع الوركين
archer_row|r|3|4|8|120|12301|low_bar|Archer Row|سحب الرامي الأفقي|Wide grip, pull toward one hand;Keep the far arm straight;Hold the body rigid|قبضة واسعة واسحب نحو يد واحدة;أبقِ الذراع البعيدة مستقيمة;حافظ على صلابة الجسم|Rotating the torso;Hips sagging|دوران الجذع;هبوط الوركين
"""),
("muscle_up","pull","Muscle-up","الماسل أب","""
chest_to_bar_pull_up|r|3|3|8|150|13300|bar|Chest-to-bar Pull-up|عقلة حتى الصدر|Pull explosively from a dead hang;Aim the lower chest at the bar;Control the way down|اسحب بانفجار من التعلق الحر;وجّه أسفل الصدر نحو البار;تحكم في النزول|Excessive kip;Stopping at the chin|تأرجح مفرط;التوقف عند الذقن
high_pull_up|r|4|2|5|180|23300|bar|High Pull-up (to the waist)|عقلة عالية حتى الخصر|Slight forward swing, then pull in an arc;Pull the bar toward the hips;Keep the bar close to the body|تأرجح خفيف للأمام ثم اسحب في قوس;اسحب البار نحو الوركين;أبقِ البار قريباً من الجسم|Pulling straight up only;Knees jerking up|السحب عمودياً فقط;رفع الركبتين بعنف
muscle_up_negative|r|3|2|5|180|33300|bar|Muscle-up Negative|ماسل أب سلبي|Start in support on top of the bar;Lower slowly through the transition;Keep the chest close to the bar|ابدأ من الارتكاز فوق البار;انزل ببطء عبر مرحلة الانتقال;أبقِ الصدر قريباً من البار|Falling through the transition;Elbows flaring wide|السقوط في مرحلة الانتقال;فتح المرفقين
kipping_muscle_up|r|4|1|5|180|33300|bar|Kipping Muscle-up|ماسل أب بالتأرجح|Use a controlled swing to pull high;Fast wrists over the bar in the transition;Finish with a full straight bar dip|استخدم تأرجحاً مضبوطاً للسحب عالياً;اقلب الرسغين بسرعة فوق البار;انتهِ بغطس كامل على البار|Chicken wing (one elbow first);No lockout at the top|صعود مرفق قبل الآخر;عدم المدّ في الأعلى
strict_muscle_up|r|4|1|5|180|33300|bar|Strict Muscle-up|ماسل أب صارم|False grip or strong high pull from dead hang;Lean the chest over the bar at sternum height;Press out to locked arms|قبضة زائفة أو سحب عالٍ قوي من التعلق الحر;أمِل صدرك فوق البار عند مستوى القص;ادفع حتى مدّ الذراعين|Using a swing;Uneven elbows in the transition|استخدام التأرجح;عدم تساوي المرفقين في الانتقال
"""),
("squat","legs","Squat","القرفصاء","""
assisted_squat|r|3|8|15|60|00011|floor|Assisted Squat|قرفصاء بمساعدة|Hold a post or doorframe for balance;Sit down between the heels;Stand up pushing through the whole foot|أمسك عموداً أو إطار باب للتوازن;اجلس بين الكعبين;انهض بالدفع من كامل القدم|Pulling up with the arms;Heels lifting|السحب بالذراعين;ارتفاع الكعبين
bodyweight_squat|r|3|10|20|60|00021|floor|Bodyweight Squat|قرفصاء بوزن الجسم|Feet shoulder width, toes slightly out;Knees track over the toes;Hips below knees if mobility allows|القدمان بعرض الكتفين والأصابع للخارج قليلاً;الركبتان باتجاه أصابع القدمين;الوركان أسفل الركبتين إن سمحت المرونة|Knees caving in;Rounding the lower back|انحراف الركبتين للداخل;تدوير أسفل الظهر
split_squat|r|3|8|12|75|00021|floor|Split Squat|قرفصاء منقسمة|Long stance, torso upright;Lower the back knee toward the floor;Drive through the front foot|وقفة طويلة والجذع منتصب;أنزل الركبة الخلفية نحو الأرض;ادفع من القدم الأمامية|Front heel lifting;Stance too narrow|ارتفاع كعب القدم الأمامية;وقفة ضيقة جداً
bulgarian_split_squat|r|3|6|12|90|00021|bench|Bulgarian Split Squat|القرفصاء البلغارية|Back foot on a bench;Drop straight down, front shin near vertical;Stand tall at the top|القدم الخلفية على مقعد;انزل عمودياً والساق الأمامية شبه عمودية;قف باستقامة في الأعلى|Pushing off the back leg;Knee collapsing inward|الدفع بالرجل الخلفية;انهيار الركبة للداخل
cossack_squat|r|3|5|10|90|00021|floor|Cossack Squat|قرفصاء القوزاق|Wide stance, sink onto one leg;Keep the other leg straight, toes up;Chest stays tall|وقفة واسعة وانزل على ساق واحدة;أبقِ الساق الأخرى مستقيمة والأصابع للأعلى;الصدر مرفوع|Heel of the bent leg lifting;Collapsing forward|ارتفاع كعب الساق المثنية;الانهيار للأمام
shrimp_squat|r|3|3|8|120|00031|floor|Shrimp Squat|قرفصاء الروبيان|Hold the rear foot behind you;Lower the back knee softly to the floor;Lean forward to balance, then stand|أمسك القدم الخلفية خلفك;أنزل الركبة الخلفية بلطف إلى الأرض;مِل للأمام للتوازن ثم انهض|Slamming the knee down;Pushing off the back toes|ضرب الركبة بالأرض;الدفع بأصابع القدم الخلفية
assisted_pistol_squat|r|3|4|8|120|00031|floor|Assisted Pistol Squat|قرفصاء المسدس بمساعدة|Hold a support with one hand;Lower on one leg with the other extended;Use as little help as possible|أمسك دعامة بيد واحدة;انزل على ساق واحدة والأخرى ممدودة;استخدم أقل مساعدة ممكنة|Dropping into the bottom;Knee caving in|السقوط في الأسفل;انحراف الركبة للداخل
pistol_squat|r|3|3|8|150|00032|floor|Pistol Squat|قرفصاء المسدس|Free leg straight in front, arms forward;Lower with control to full depth;Stand without bouncing|الساق الحرة ممدودة أماماً والذراعان للأمام;انزل بتحكم إلى العمق الكامل;انهض دون ارتداد|Heel lifting;Rounding and falling back|ارتفاع الكعب;تدوير الظهر والسقوط للخلف
"""),
("hinge","legs","Posterior Chain","السلسلة الخلفية","""
glute_bridge|r|3|10|20|60|00011|floor|Glute Bridge|جسر المؤخرة|Feet flat, heels close to the hips;Lift the hips by squeezing the glutes;Pause one second at the top|القدمان مسطحتان والكعبان قرب الوركين;ارفع الوركين بشدّ المؤخرة;توقف ثانية في الأعلى|Arching the lower back;Pushing through the toes|تقوّس أسفل الظهر;الدفع من أصابع القدم
single_leg_glute_bridge|r|3|8|15|60|00011|floor|Single-leg Glute Bridge|جسر المؤخرة بساق واحدة|One foot down, other knee to the chest;Keep the hips level as you lift;Lower slowly|قدم على الأرض والركبة الأخرى نحو الصدر;حافظ على استواء الوركين عند الرفع;انزل ببطء|Hips rotating;Hamstring taking over with feet too far|دوران الوركين;ابتعاد القدم فيعمل الخلفي وحده
hamstring_slide_curl|r|3|6|12|90|00022|floor|Hamstring Slide Curl|ثني خلفي بالانزلاق|Heels on a towel or sliders, hips lifted;Slide the heels out slowly;Pull back keeping the hips high|الكعبان على منشفة أو زلاقات والوركان مرفوعان;ادفع الكعبين للخارج ببطء;اسحب للخلف مع إبقاء الوركين عالياً|Hips dropping;Rushing the extension|هبوط الوركين;التسرع في المدّ
nordic_curl_negative|r|3|3|6|120|00032|floor|Nordic Curl Negative|نورديك سلبي|Anchor the ankles, kneel tall;Lower the body as slowly as possible;Catch with the hands and push back up|ثبّت الكاحلين واجثُ باستقامة;أنزل الجسم بأبطأ ما يمكن;استقبل بيديك وادفع للعودة|Breaking at the hips;Falling the last half|الانثناء من الوركين;السقوط في النصف الأخير
nordic_curl|r|3|2|6|150|00032|floor|Nordic Curl|نورديك كيرل|Body straight from knees to head;Lower under control to the floor;Pull back up with the hamstrings|الجسم مستقيم من الركبتين إلى الرأس;انزل بتحكم إلى الأرض;عد للأعلى بعضلات الفخذ الخلفية|Hips shooting back;Big push from the hands|رجوع الوركين للخلف;دفع قوي باليدين
"""),
("leg_raise","core","Leg Raise","رفع الساقين","""
lying_knee_raise|r|3|10|15|60|00001|floor|Lying Knee Raise|رفع الركبتين استلقاءً|Lower back pressed into the floor;Bring the knees over the hips;Lower the feet slowly|أسفل الظهر ملتصق بالأرض;اجلب الركبتين فوق الوركين;أنزل القدمين ببطء|Back arching off the floor;Using momentum|ارتفاع الظهر عن الأرض;استخدام الزخم
lying_leg_raise|r|3|8|15|60|00002|floor|Lying Leg Raise|رفع الساقين استلقاءً|Legs straight, hands by the sides;Raise the legs to vertical;Lower until just above the floor|الساقان مستقيمتان واليدان بجانب الجسم;ارفع الساقين حتى الوضع العمودي;انزل حتى قرب الأرض|Lower back lifting;Dropping the legs|ارتفاع أسفل الظهر;إسقاط الساقين
hanging_knee_raise|r|3|8|15|75|12101|bar|Hanging Knee Raise|رفع الركبتين تعلقاً|Hang with active shoulders;Curl the knees to the chest;Lower without swinging|تعلّق بكتفين نشطين;اثنِ الركبتين نحو الصدر;انزل دون تأرجح|Swinging;Only lifting the thighs to horizontal|التأرجح;رفع الفخذين حتى الأفق فقط
hanging_leg_raise|r|3|5|12|90|12102|bar|Hanging Leg Raise|رفع الساقين تعلقاً|Straight legs, toes pointed;Raise to horizontal or higher;Control the descent|ساقان مستقيمتان وأصابع مشدودة;ارفع حتى الأفق أو أعلى;تحكم في النزول|Bending the knees;Kipping|ثني الركبتين;التأرجح للمساعدة
toes_to_bar|r|3|4|10|120|12102|bar|Toes to Bar|أصابع القدم إلى البار|Pull down on the bar with straight arms;Lift straight legs until toes touch the bar;Lower slowly|اضغط على البار بذراعين مستقيمتين;ارفع الساقين حتى تلمس الأصابع البار;انزل ببطء|Swinging for momentum;Bending the arms|التأرجح لكسب الزخم;ثني الذراعين
"""),
("plank","core","Plank","البلانك","""
knee_plank|h|3|20|45|45|11001|floor|Knee Plank|بلانك على الركبتين|Elbows under shoulders;Straight line from knees to head;Squeeze glutes and abs|المرفقان تحت الكتفين;خط مستقيم من الركبتين إلى الرأس;اشدد المؤخرة والبطن|Hips too high;Head hanging|الوركان مرتفعان جداً;تدلّي الرأس
plank|h|3|20|60|60|11001|floor|Plank|بلانك|Elbows under shoulders, feet together;Tuck the pelvis and brace;Push the floor away|المرفقان تحت الكتفين والقدمان معاً;أدر الحوض للداخل واشدد البطن;ادفع الأرض|Sagging lower back;Holding the breath|هبوط أسفل الظهر;حبس النفس
side_plank|h|3|15|45|60|12101|floor|Side Plank|بلانك جانبي|Elbow under the shoulder, feet stacked;Lift the hips to a straight line;Hold each side|المرفق تحت الكتف والقدمان فوق بعضهما;ارفع الوركين إلى خط مستقيم;اثبت على كل جانب|Hips dropping;Rolling forward|هبوط الوركين;الدوران للأمام
hollow_body_hold|h|3|15|45|60|00002|floor|Hollow Body Hold|ثبات الجسم المجوّف|Lower back glued to the floor;Arms overhead, legs straight and low;Scale by tucking the knees|أسفل الظهر ملتصق بالأرض;الذراعان فوق الرأس والساقان مستقيمتان ومنخفضتان;سهّل بثني الركبتين|Lower back arching;Chin jutting out|تقوّس أسفل الظهر;بروز الذقن
"""),
("l_sit","core","L-sit","وضعية L","""
foot_supported_l_sit|h|3|10|30|60|21101|floor|Foot-supported L-sit|L-sit مع دعم القدمين|Hands by the hips, press the floor;Lift the hips, heels stay down;Shoulders pressed down|اليدان بجانب الوركين واضغط الأرض;ارفع الوركين والكعبان على الأرض;الكتفان للأسفل|Shoulders shrugged;Bent arms|رفع الكتفين;ثني الذراعين
tuck_l_sit|h|3|10|30|75|22101|floor|Tuck L-sit|L-sit مضموم|Lock the arms and lift the feet;Knees to the chest;Push tall through the shoulders|مدّ الذراعين وارفع القدمين;الركبتان نحو الصدر;ادفع عالياً من الكتفين|Leaning back;Sinking into the shoulders|الميل للخلف;الغوص في الكتفين
one_leg_l_sit|h|3|8|20|75|22102|floor|One-leg L-sit|L-sit بساق واحدة|From tuck, extend one leg straight;Keep the extended leg horizontal;Switch legs each set|من الوضع المضموم مدّ ساقاً واحدة;أبقِ الساق الممدودة أفقية;بدّل الساقين كل مجموعة|Extended leg dropping;Rounded shoulders|هبوط الساق الممدودة;تدوير الكتفين
l_sit|h|3|8|30|90|22102|floor|L-sit|وضعية L|Arms locked, both legs straight and horizontal;Point the toes, squeeze the quads;Depress the shoulders|الذراعان ممدودتان والساقان مستقيمتان أفقياً;شدّ أصابع القدم والفخذين;اخفض الكتفين|Bent knees;Legs below horizontal|ثني الركبتين;الساقان تحت الأفق
v_sit|h|3|5|15|120|33102|floor|V-sit|وضعية V|From L-sit, lift the legs higher;Push the hips forward between the hands;Keep the arms locked|من وضعية L ارفع الساقين أعلى;ادفع الوركين للأمام بين اليدين;أبقِ الذراعين ممدودتين|Leaning back without lifting the hips;Bent arms|الميل للخلف دون رفع الوركين;ثني الذراعين
"""),
("dragon_flag","core","Dragon Flag","علم التنين","""
tuck_dragon_flag|r|3|3|8|120|02102|bench|Tuck Dragon Flag|علم التنين المضموم|Grip the bench behind the head;Lift onto the shoulders with knees tucked;Lower as one piece|أمسك المقعد خلف الرأس;ارتفع على الكتفين والركبتان مضمومتان;انزل كقطعة واحدة|Bending at the hips;Weight on the neck|الانثناء من الوركين;تحميل الرقبة
dragon_flag_negative|r|3|2|5|150|02103|bench|Dragon Flag Negative|علم التنين السلبي|Start vertical on the shoulders, body straight;Lower slowly for 4 to 6 seconds;Reset at the top with bent knees|ابدأ عمودياً على الكتفين والجسم مستقيم;انزل ببطء خلال ٤ إلى ٦ ثوانٍ;عد للأعلى بثني الركبتين|Hips piking;Dropping near the bottom|انثناء الوركين;السقوط قرب الأسفل
dragon_flag|r|3|2|6|150|02103|bench|Dragon Flag|علم التنين|Body rigid from shoulders to toes;Lower until just above the bench;Raise without bending the hips|الجسم صلب من الكتفين إلى الأصابع;انزل حتى قرب المقعد;ارتفع دون ثني الوركين|Arching the lower back;Using the neck|تقوّس أسفل الظهر;استخدام الرقبة
"""),
("handstand","statics","Handstand","الوقوف على اليدين","""
crow_pose|h|3|8|30|60|31200|floor|Crow Pose|وضعية الغراب|Knees on the upper arms, look forward;Lean until the feet float;Grip the floor with the fingertips|الركبتان على العضدين والنظر للأمام;مِل حتى ترتفع القدمان;اقبض على الأرض بأطراف الأصابع|Looking down at the hands;Jumping into it|النظر إلى اليدين;القفز إلى الوضعية
wall_walk|r|3|2|5|120|32201|wall|Wall Walk|المشي على الحائط|Start in a push-up with feet at the wall;Walk the feet up and the hands in;Walk back down under control|ابدأ بوضع الضغط والقدمان عند الحائط;اصعد بالقدمين وقرّب اليدين;انزل بتحكم|Arching the back;Coming down too fast|تقوّس الظهر;النزول بسرعة
chest_to_wall_handstand|h|3|15|45|90|32101|wall|Chest-to-wall Handstand|الوقوف على اليدين والصدر للحائط|Hands close to the wall, only toes touching;Push tall, ears between the arms;Ribs in, glutes tight|اليدان قرب الحائط والأصابع فقط تلامسه;ادفع عالياً والأذنان بين الذراعين;الأضلاع للداخل والمؤخرة مشدودة|Banana shape;Bent elbows|شكل الموزة;ثني المرفقين
handstand_kick_up|r|4|3|6|90|32101|floor|Handstand Kick-up|الصعود إلى الوقوف على اليدين|Lunge, place hands shoulder width;Kick gently to find the balance point;Learn to bail by cartwheeling out|تقدّم وضع اليدين بعرض الكتفين;اركل بلطف لإيجاد نقطة التوازن;تعلّم الخروج الآمن بالعجلة|Kicking too hard;Bent arms on entry|الركل بقوة زائدة;ثني الذراعين عند الصعود
freestanding_handstand|h|4|5|30|120|32101|floor|Freestanding Handstand|الوقوف الحر على اليدين|Stack wrists, shoulders, hips and ankles;Balance with finger pressure;Squeeze everything, point the toes|صفّ الرسغين والكتفين والوركين والكاحلين;وازن بضغط الأصابع;شدّ كامل الجسم وأصابع القدم|Walking on the hands to save balance;Head sticking far out|المشي باليدين لحفظ التوازن;إخراج الرأس كثيراً
"""),
("planche","statics","Planche","البلانش","""
planche_lean|h|3|10|30|90|32201|floor|Planche Lean|ميل البلانش|Push-up position, arms locked;Lean the shoulders past the wrists;Round the upper back and tuck the pelvis|وضع الضغط والذراعان ممدودتان;أمِل الكتفين أمام الرسغين;دوّر أعلى الظهر وأدر الحوض|Bending the elbows;Hips piked high|ثني المرفقين;رفع الوركين عالياً
tuck_planche|h|4|5|20|120|33301|floor|Tuck Planche|البلانش المضموم|Arms locked, knees to the chest;Lift the hips to shoulder height;Protract the shoulder blades hard|الذراعان ممدودتان والركبتان نحو الصدر;ارفع الوركين إلى مستوى الكتفين;باعد لوحي الكتف بقوة|Bent arms;Hips lower than shoulders|ثني الذراعين;الوركان أدنى من الكتفين
advanced_tuck_planche|h|4|5|15|150|33301|floor|Advanced Tuck Planche|البلانش المضموم المتقدم|Flatten the back, knees away from the chest;Hips level with the shoulders;Keep leaning forward|سطّح الظهر وأبعد الركبتين عن الصدر;الوركان بمستوى الكتفين;واصل الميل للأمام|Rounded lower back;Losing the lean|تدوير أسفل الظهر;فقدان الميل
straddle_planche|h|4|3|12|180|33302|floor|Straddle Planche|البلانش المفتوح|Extend the legs wide behind you;Body parallel to the floor;Squeeze the glutes and point the toes|مدّ الساقين متباعدتين خلفك;الجسم موازٍ للأرض;شدّ المؤخرة وأصابع القدم|Arched back with low hips;Bent elbows|ظهر مقوّس ووركان منخفضان;ثني المرفقين
full_planche|h|4|2|10|180|33302|floor|Full Planche|البلانش الكامل|Legs together, body in one line;Shoulders far in front of the hands;Arms locked, full protraction|الساقان معاً والجسم على خط واحد;الكتفان متقدمان كثيراً أمام اليدين;الذراعان ممدودتان مع مباعدة كاملة للوحين|Piked hips;Bent arms|انثناء الوركين;ثني الذراعين
"""),
("front_lever","statics","Front Lever","الرافعة الأمامية","""
tuck_front_lever|h|4|5|20|120|12201|bar|Tuck Front Lever|الرافعة الأمامية المضمومة|Hang, pull the knees to the chest;Tilt back until the back is horizontal;Straight arms, shoulders pulled down|تعلّق واسحب الركبتين نحو الصدر;مِل للخلف حتى يصبح الظهر أفقياً;ذراعان مستقيمتان وكتفان للأسفل|Bent arms;Hips sagging below the shoulders|ثني الذراعين;هبوط الوركين تحت الكتفين
advanced_tuck_front_lever|h|4|5|15|150|13201|bar|Advanced Tuck Front Lever|الرافعة الأمامية المضمومة المتقدمة|Flat back, knees over the hips;Pull the bar toward the hips;Keep the arms straight|ظهر مسطّح والركبتان فوق الوركين;اسحب البار نحو الوركين;أبقِ الذراعين مستقيمتين|Rounded back;Shoulders rising|تدوير الظهر;ارتفاع الكتفين
one_leg_front_lever|h|4|4|12|150|13202|bar|One-leg Front Lever|الرافعة الأمامية بساق واحدة|Extend one leg, keep the other tucked;Body horizontal from shoulders to foot;Switch legs each set|مدّ ساقاً واحدة وأبقِ الأخرى مضمومة;الجسم أفقي من الكتفين إلى القدم;بدّل الساقين كل مجموعة|Extended leg dropping;Hips piking|هبوط الساق الممدودة;انثناء الوركين
straddle_front_lever|h|4|3|12|180|13202|bar|Straddle Front Lever|الرافعة الأمامية المفتوحة|Both legs straight and wide;Hips fully open;Depress and retract the shoulder blades|الساقان مستقيمتان ومتباعدتان;الوركان مفتوحان تماماً;اخفض لوحي الكتف وقرّبهما|Bent hips;Bent arms|ثني الوركين;ثني الذراعين
front_lever|h|4|2|10|180|13202|bar|Front Lever|الرافعة الأمامية|Legs together, body one straight line;Pull the bar to the hips with straight arms;Squeeze glutes and abs|الساقان معاً والجسم خط مستقيم;اسحب البار نحو الوركين بذراعين مستقيمتين;شدّ المؤخرة والبطن|Sagging hips;Head tilted far back|هبوط الوركين;إمالة الرأس كثيراً للخلف
"""),
]

JOINTS = ["wrists","shoulders","elbows","knees","lowerBack"]
LEVELS = ["none","low","medium","high"]
out = {"version": 1, "chains": [], "exercises": []}
for cid, pattern, en, ar, body in CHAINS:
    rows = [l.split("|") for l in body.strip().splitlines()]
    out["chains"].append({"id": cid, "pattern": pattern, "name": {"en": en, "ar": ar}})
    for i, r in enumerate(rows):
        assert len(r) == 14, r[0]
        (eid, typ, sets, mn, mx, rest, stress, equip, nen, nar, cen, car, men, mar) = r
        out["exercises"].append({
            "id": eid, "pattern": pattern, "chain": cid, "level": i + 1,
            "type": "reps" if typ == "r" else "hold",
            "defaults": {"sets": int(sets), "min": int(mn), "max": int(mx), "restSec": int(rest)},
            "jointStress": {j: LEVELS[int(s)] for j, s in zip(JOINTS, stress)},
            "equipment": equip.split(","),
            "regression": rows[i - 1][0] if i else None,
            "progression": rows[i + 1][0] if i + 1 < len(rows) else None,
            "media": None,
            "name": {"en": nen, "ar": nar},
            "cues": {"en": cen.split(";"), "ar": car.split(";")},
            "mistakes": {"en": men.split(";"), "ar": mar.split(";")},
        })
p = os.path.join(os.path.dirname(__file__), "..", "assets", "data", "exercises.json")
json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(len(out["exercises"]), "exercises,", len(out["chains"]), "chains")
