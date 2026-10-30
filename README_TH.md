# Post-Match Network Evidence (MVP)

เว็บบันทึกผลตรวจหลังจบเกม ผู้เล่น Android/iPhone เปิดลิงก์และกดยินยอมส่งรายงานเอง

## ข้อจำกัดสำคัญ
- เว็บเบราว์เซอร์อ่านประวัติ VPN / Proxy / DNS ของทั้งเครื่องย้อนหลังไม่ได้
- เว็บนี้ไม่สแกนรายการแอป และไม่ตรวจจับโปรโกง
- ค่า VPN / Proxy / DNS เป็นคำรายงานของผู้เล่น ไม่ใช่ผลสแกนยืนยัน
- navigator.onLine, user-agent และเขตเวลา ไม่สามารถพิสูจน์ว่ามีหรือไม่มี VPN
- ถ้าต้องการหลักฐานย้อนหลังจริง ต้องมีระบบที่ได้รับอนุญาตบันทึกตั้งแต่ก่อนแข่ง
- การพบ VPN หรือ DNS แบบกำหนดเองไม่ได้พิสูจน์ว่าโกง

## สิ่งที่ MVP ทำได้
- หน้า player.html ให้ผู้เล่นยินยอมและส่งรายงานหลังเกม
- บันทึกรหัสแมตช์ ชื่อ/UID แพลตฟอร์ม และคำตอบ VPN / Proxy / DNS
- บันทึกเวลาจากฐานข้อมูล Supabase
- หน้า admin.html ให้ผู้ดูแลล็อกอินและดูรายงาน 30 นาทีล่าสุด
- ข้อมูลเก็บใน Supabase ไม่ได้เก็บเฉพาะใน iPhone

## ตั้งค่า Supabase
1. เปิด https://supabase.com ใน Safari และสร้างโปรเจกต์
2. ไป SQL Editor > New query
3. วางเนื้อหาไฟล์ supabase/schema.sql แล้ว Run
4. ไป Project Settings > API คัดลอก Project URL และ anon/publishable key
5. ใส่ค่าลง public/config.js (ห้ามใช้ service_role key)
6. ไป Authentication > Users > Add user เพื่อสร้างบัญชีผู้ดูแล
7. ใน SQL Editor รันคำสั่งนี้ โดยแทนอีเมลให้ตรงกับบัญชีผู้ดูแล (ทำให้บัญชีนี้มีสิทธิ์อ่านรายงาน):
   `update auth.users set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb where email = 'อีเมลผู้ดูแล';`
8. อย่าเปิดให้บุคคลอื่นเป็น admin และอย่าแชร์บัญชีผู้ดูแล

## เผยแพร่เว็บผ่าน iPhone
1. แตก ZIP ในแอป Files
2. อัปโหลดไฟล์ภายในโฟลเดอร์ public ไปยัง GitHub repository ผ่าน Safari
3. เปิด https://vercel.com เข้าด้วย GitHub แล้ว Import repository
4. ตั้ง Root Directory เป็น public แล้ว Deploy
5. ส่งลิงก์ /player.html ให้ผู้เล่น และใช้ /admin.html สำหรับผู้ดูแล

## การเก็บ 30 นาที
หน้าแอดมินแสดงเฉพาะ 30 นาทีล่าสุด แต่ฐานข้อมูลยังเก็บรายงานไว้ หากต้องการลบอัตโนมัติ ให้เปิดใช้ pg_cron แล้วรัน supabase/optional_cleanup.sql
ห้ามเปิด public SELECT และห้ามใส่ service_role key ในเว็บ
