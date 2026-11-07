-- HAX ANIMATOR v3.9.3 (R6/R15) - Delta. Termina com a linha "-- FIM"; se faltar, a copia foi cortada.
local function __HAX_MAIN()
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local HttpService=game:GetService("HttpService")
local LP=Players.LocalPlayer
local UO,UN,RGB,V2,FT,XL=UDim2.fromOffset,UDim2.new,Color3.fromRGB,Vector2.new,Enum.Font,Enum.TextXAlignment.Left
local BT,BC="BackgroundTransparency","BackgroundColor3"
local AP5=V2(0.5,0.5)
local ENV=(getgenv and getgenv()) or _G
local TBX_URL="https://voxelchat-d2491-default-rtdb.firebaseio.com/"
for _,k in ipairs({"__HaxAnimator","__MoonAnimMobile"}) do
local f=ENV[k] or _G[k]
if f then pcall(f) end
end
local PARTS={"Torso","Head","Right Arm","Left Arm","Right Leg","Left Leg"}
local MOTOR={
["Torso"]={"HumanoidRootPart","RootJoint"},
["Head"]={"Torso","Neck"},
["Right Arm"]={"Torso","Right Shoulder"},
["Left Arm"]={"Torso","Left Shoulder"},
["Right Leg"]={"Torso","Right Hip"},
["Left Leg"]={"Torso","Left Hip"},
}
local EASES={"Linear","Quad","Cubic","Quart","Quint","Sine","Exponential","Circular","Back","Elastic","Bounce","Constant"}
local DIRS={"In","Out","InOut"}
local TITLE_H,MENU_H,TOOL_H=22,20,28
local BODY_Y=TITLE_H+MENU_H+TOOL_H          -- 70
local NAMES_W=90
local PAD,RULER=8,16
local ROW,BODY_H,INFO_Y,WIN_W,WIN_H=20,136,210,440,274
local S={
rig=nil,motors={},tracks={},name="Anim1",
fps=30,len=60,loop=true,cur=0,playing=false,
ppf=5,sel="Torso",selKey=nil,
theme="Laranja",alpha=0,scale=1,w=440,h=274,
kfColor=RGB(255,150,30),kfSel=Color3.new(1,1,1),
ease="Linear",dir="In",
autokey=true,autosave=true,anchor=false,
gmode="move",space="local",stepMove=0.2,stepRot=5,follow=true,endLast=true,lock0=true,prio="Action",bgId="",expBake=true,ik=false,pins={},pins15={},lang="pt-BR",orig=setmetatable({},{__mode="k"}),origPh=setmetatable({},{__mode="k"}),miss={},
ghost=false,clip=nil,dirty=false,selSet={},selMode=false,kfClip=nil,selBtn=nil,
xids={},xmeta={},xinit={},xroots={},xrigs={},xbyInst={},xopen={},xmode=false,xrow0=1,xn=0,panels={},ids={},
}
for _,p in ipairs(PARTS) do S.tracks[p]={}; S.ids[#S.ids+1]=p end
local function calcDims()
S.w=math.clamp(math.floor(S.w),440,720)
S.h=math.clamp(math.floor(S.h),270,430)
ROW=math.floor((S.h - 154)/6)
BODY_H=RULER+ROW*6
INFO_Y=BODY_Y+BODY_H+4
WIN_W=S.w
WIN_H=INFO_Y+16+48
end
local function mkTheme(a,tt,dark)
local t={
accent=a,
accent2=a:Lerp(Color3.new(0,0,0),0.5),
text=RGB(236,238,246),
sub=RGB(142,148,170),
ttext=tt or Color3.new(1,1,1),
}
if dark then
t.bg=RGB(10,10,11); t.bg2=RGB(18,18,20)
t.bg3=RGB(30,30,33); t.line=RGB(48,48,53)
t.sub=RGB(132,132,138)
else
t.bg=RGB(15,16,24); t.bg2=RGB(23,25,37)
t.bg3=RGB(36,39,57); t.line=RGB(52,56,80)
end
return t
end
local THEMES={
["Amarelo"]=mkTheme(RGB(240,200,40),Color3.new(0,0,0)),
["Laranja"]=mkTheme(RGB(255,140,26)),
["Azul"]=mkTheme(RGB(52,132,240)),
["Roxo"]=mkTheme(RGB(136,74,210)),
["Vermelho"]=mkTheme(RGB(215,52,52)),
["Lilás"]=mkTheme(RGB(198,160,242),Color3.new(0,0,0)),
["Dark"]=mkTheme(RGB(96,96,104),nil,true),
}
local THEME_ORDER={"Amarelo","Laranja","Azul","Roxo","Vermelho","Lilás","Dark"}
local function TH() return THEMES[S.theme] end
local function A(b)
if S.bgId~="" and b<0.4 then b=0.4 end
return b+(1 - b)*S.alpha
end
local FILE="HaxAnimator_" .. LP.UserId .. ".json"
local OLDFILE="MoonAnimMobile_" .. LP.UserId .. ".json"
local fs=(typeof(writefile)=="function" and typeof(readfile)=="function" and typeof(isfile)=="function")
local DB={anims={},settings={}}
local dbSave
do
local function readRaw()
if fs then
for _,f in ipairs({FILE,OLDFILE}) do
if isfile(f) then
local ok,r=pcall(readfile,f)
if ok and r and r~="" then return r end
end
end
else
return _G["HAX_" .. LP.UserId]
end
end
local function dbLoad()
local raw=readRaw()
if not raw then return end
local ok,d=pcall(function() return HttpService:JSONDecode(raw) end)
if ok and type(d)=="table" then
DB.anims=d.anims or {}
DB.settings=d.settings or {}
DB.autosave=d.autosave; DB.tbx=d.tbx
end
end
function dbSave()
local ok,raw=pcall(function() return HttpService:JSONEncode(DB) end)
if not ok then return end
if fs then pcall(writefile,FILE,raw) else _G["HAX_" .. LP.UserId]=raw end
end
dbLoad()
end
do
local st=DB.settings
if type(st.accent)=="table" and #st.accent==3 then
S.customAccent=Color3.new(st.accent[1],st.accent[2],st.accent[3])
THEMES.Custom=mkTheme(S.customAccent,(0.299*st.accent[1]+0.587*st.accent[2]+0.114*st.accent[3])>0.6 and Color3.new(0,0,0) or nil)
end
if type(st.kfsel)=="table" and #st.kfsel==3 then S.kfSel=Color3.new(st.kfsel[1],st.kfsel[2],st.kfsel[3]) end
if THEMES[st.theme] then S.theme=st.theme end
if type(st.alpha)=="number" then S.alpha=math.clamp(st.alpha,0,0.9) end
if type(st.scale)=="number" then S.scale=math.clamp(st.scale,0.5,1.4) end
if type(st.w)=="number" then S.w=st.w end
if type(st.h)=="number" then S.h=st.h end
if type(st.kf)=="table" and #st.kf==3 then S.kfColor=Color3.new(st.kf[1],st.kf[2],st.kf[3]) end
if type(st.ppf)=="number" then S.ppf=math.clamp(st.ppf,2,30) end
if type(st.autokey)=="boolean" then S.autokey=st.autokey end
if type(st.autosave)=="boolean" then S.autosave=st.autosave end
if type(st.stepMove)=="number" then S.stepMove=math.clamp(st.stepMove,0.001,1) end
if type(st.stepRot)=="number" then S.stepRot=math.clamp(st.stepRot,1,90) end
if type(st.lock0)=="boolean" then S.lock0=st.lock0 end
if type(st.expBake)=="boolean" then S.expBake=st.expBake end
if st.lang=="pt-BR" or st.lang=="pt-PT" or st.lang=="es" or st.lang=="en" then S.lang=st.lang end
if type(st.bgId)=="string" then S.bgId=(st.bgId:gsub("%D","")) end
if type(st.follow)=="boolean" then S.follow=st.follow end
if type(st.endLast)=="boolean" then S.endLast=st.endLast end
end
calcDims()
local function saveSettings()
DB.settings={
theme=S.theme,alpha=S.alpha,scale=S.scale,ppf=S.ppf,w=S.w,h=S.h,
kf={S.kfColor.R,S.kfColor.G,S.kfColor.B},kfsel={S.kfSel.R,S.kfSel.G,S.kfSel.B},accent=S.customAccent and {S.customAccent.R,S.customAccent.G,S.customAccent.B} or nil,autokey=S.autokey,autosave=S.autosave,
stepMove=S.stepMove,stepRot=S.stepRot,follow=S.follow,endLast=S.endLast,lock0=S.lock0,bgId=S.bgId,expBake=S.expBake,lang=S.lang,
}
dbSave()
end
local function sortT(t) table.sort(t,function(a,b) return a.f<b.f end) end
local function getKey(part,f)
for _,k in ipairs(S.tracks[part]) do if k.f==f then return k end end
end
local function keyCF(k)
return CFrame.new(k.px,k.py,k.pz)*CFrame.Angles(math.rad(k.rx),math.rad(k.ry),math.rad(k.rz))
end
local E={}
function E.bounce(t)
if t<1/2.75 then return 7.5625*t*t
elseif t<2/2.75 then t=t - 1.5/2.75; return 7.5625*t*t+0.75
elseif t<2.5/2.75 then t=t - 2.25/2.75; return 7.5625*t*t+0.9375 end
t=t - 2.625/2.75
return 7.5625*t*t+0.984375
end
function E.easeIn(style,t)
if style=="Sine" then return 1 - math.cos(t*math.pi/2)
elseif style=="Quad" then return t*t
elseif style=="Cubic" then return t*t*t
elseif style=="Quart" then return t*t*t*t
elseif style=="Quint" then return t*t*t*t*t
elseif style=="Exponential" then
if t<=0 then return 0 end
return 2^(10*(t - 1))
elseif style=="Circular" then return 1 - math.sqrt(math.max(0,1 - t*t))
elseif style=="Back" then return t*t*(2.70158*t - 1.70158)
elseif style=="Elastic" then
if t<=0 then return 0 elseif t>=1 then return 1 end
return -(2^(10*t - 10))*math.sin((10*t - 10.75)*(2*math.pi/3))
elseif style=="Bounce" then return 1 - E.bounce(1 - t)
end
return t
end
function E.ease(a,style,dir)
if style=="Constant" then return a>=1 and 1 or 0 end
if a<0 then a=0 elseif a>1 then a=1 end
if dir=="Out" then return 1 - E.easeIn(style,1 - a)
elseif dir=="InOut" then
if a<0.5 then return E.easeIn(style,a*2)/2 end
return 1 - E.easeIn(style,2 - a*2)/2
end
return E.easeIn(style,a)
end
function E.lerp(a,b,alpha)
local pa,pb=a.Position,b.Position
local ra,rb=a - pa,b - pb
local rot=ra
local axis,ang=(ra:Inverse()*rb):ToAxisAngle()
if ang>1e-6 and axis.Magnitude>1e-6 then rot=ra*CFrame.fromAxisAngle(axis,ang*alpha) end
return rot+(pa+(pb - pa)*alpha)
end
function S.evalRaw(part,f)
local t=S.tracks[part]
if #t==0 then return CFrame.new() end
if f<=t[1].f then return keyCF(t[1]) end
if f>=t[#t].f then return keyCF(t[#t]) end
for i=2,#t do
local b=t[i]
if f<=b.f then
local a=t[i - 1]
local alpha=E.ease((f - a.f)/(b.f - a.f),a.e,a.d)
return E.lerp(keyCF(a),keyCF(b),alpha)
end
end
return keyCF(t[#t])
end
local function evalPart(part,f)
local cf=S.evalRaw(part,f)
return cf
end
local X={}
X.CLS={
{"BasePart",true,{"Transparency"}},
{"Attachment",true,{}},
{"Beam",false,{"Width0","Width1","Enabled"}},
{"Trail",false,{"Lifetime","Enabled"}},
{"ParticleEmitter",false,{"Rate","Enabled"}},
{"PointLight",false,{"Brightness","Range","Enabled"}},
{"SpotLight",false,{"Brightness","Range","Enabled"}},
{"SurfaceLight",false,{"Brightness","Range","Enabled"}},
{"Fire",false,{"Enabled"}},
{"Smoke",false,{"Enabled"}},
{"Sparkles",false,{"Enabled"}},
{"Decal",false,{"Transparency"}},
{"Texture",false,{"Transparency"}},
}
function X.classInfo(inst)
for _,c in ipairs(X.CLS) do
local ok,r=pcall(function() return inst:IsA(c[1]) end)
if ok and r then return c[2],c[3],c[1] end
end
end
function X.kindInfo(kind)
for _,c in ipairs(X.CLS) do
if c[1]==kind then return c[2],c[3] end
end
end
function X.pathOf(inst)
local t,cur={},inst
while cur and cur~=game do
table.insert(t,1,cur.Name)
cur=cur.Parent
end
return t
end
function X.resolve(path)
local cur=game
for _,n in ipairs(path) do
cur=cur and cur:FindFirstChild(n)
if not cur then return nil end
end
return cur
end
function X.readChan(inst,name)
local ok,v=pcall(function() return inst[name] end)
if not ok then return 0 end
if type(v)=="boolean" then return v and 1 or 0 end
return tonumber(v) or 0
end
function X.capture(inst,tf,ch)
local ini={ch={}}
if tf then ini.cf=inst.CFrame end
for i,n in ipairs(ch) do ini.ch[i]=X.readChan(inst,n) end
return ini
end
function X.evalChan(id,f)
local mt,ini,t=S.xmeta[id],S.xinit[id],S.tracks[id]
local out={}
local n=mt and #mt.ch or 0
local function kv(k,i) return k["c" .. i] or (ini and ini.ch[i]) or 0 end
if not t or #t==0 then
for i=1,n do out[i]=ini and ini.ch[i] or 0 end
return out
end
if f<=t[1].f then for i=1,n do out[i]=kv(t[1],i) end return out end
if f>=t[#t].f then for i=1,n do out[i]=kv(t[#t],i) end return out end
for j=2,#t do
local b=t[j]
if f<=b.f then
local a=t[j-1]
if f==b.f then for i=1,n do out[i]=kv(b,i) end return out end
local al=E.ease((f - a.f)/(b.f - a.f),a.e,a.d)
for i=1,n do
if mt.ch[i]=="Enabled" then out[i]=kv(a,i)
else out[i]=kv(a,i)+(kv(b,i) - kv(a,i))*al end
end
return out
end
end
return out
end
function X.setChan(inst,name,v)
if name=="Enabled" then pcall(function() inst.Enabled=v>=0.5 end)
else pcall(function() inst[name]=v end) end
end
function X.apply(id,f)
local mt,ini=S.xmeta[id],S.xinit[id]
if mt and mt.motor then
if ini and ini.c0 then pcall(function() mt.motor.C0=ini.c0*evalPart(id,f) end) end
return
end
local inst=mt and mt.inst
if not (inst and ini and inst.Parent) then return end
if mt.tf and ini.cf then pcall(function() inst.CFrame=ini.cf*evalPart(id,f) end) end
if #mt.ch>0 then
local v=X.evalChan(id,f)
for i,n in ipairs(mt.ch) do X.setChan(inst,n,v[i]) end
end
end
function X.restore(id)
local mt,ini=S.xmeta[id],S.xinit[id]
if mt and mt.motor then
if ini and ini.c0 then pcall(function() mt.motor.C0=ini.c0 end) end
return
end
local inst=mt and mt.inst
if not (inst and ini and inst.Parent) then return end
if mt.tf and ini.cf then pcall(function() inst.CFrame=ini.cf end) end
for i,n in ipairs(mt.ch) do X.setChan(inst,n,ini.ch[i]) end
end
function X.place(r)
for _,part in ipairs(PARTS) do
local m=r.motors[part]
if m and m.Part0 and m.Part1 then pcall(function() m.Part1.CFrame=m.Part0.CFrame*m.C0*m.C1:Inverse() end) end
end
end
function X.restoreAll()
for _,id in ipairs(S.xids) do X.restore(id) end
for _,r in ipairs(S.xrigs) do
if r.manual then X.place(r) end
X.attPlace(r)
end
end
function X.isR6(model)
if not (model:FindFirstChildOfClass("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Torso")) then return nil end
local motors={}
for part,info in pairs(MOTOR) do
local holder=model:FindFirstChild(info[1])
local m=holder and holder:FindFirstChild(info[2])
if not (m and m:IsA("Motor6D")) then return nil end
motors[part]=m
end
return motors
end
function X.addRig(model,motors)
motors=motors or X.isR6(model)
if not motors or model==S.rig then return false end
local r={model=model,motors={},ids={},manual=false}
local an=model:FindFirstChild("Animate")
r.animWas=an and an.Disabled
if an then an.Disabled=true end
for _,part in ipairs(PARTS) do
local limb=model:FindFirstChild(part)
if limb and X.anch(limb) then r.manual=true end
local m=motors[part]
S.xn=S.xn+1
local id="x" .. S.xn
S.xmeta[id]={path=X.pathOf(limb or model),kind="Motor",inst=limb,tf=true,ch={},motor=m,part=part,rig=r}
S.xinit[id]={ch={},c0=m.C0}
S.tracks[id]={}
S.xids[#S.xids+1]=id
if limb then S.xbyInst[limb]=id end
r.motors[part]=m; r.ids[part]=id
end
r.hrp=model:FindFirstChild("HumanoidRootPart")
local core={[r.hrp]="HumanoidRootPart"}
for _,part in ipairs(PARTS) do
local limb=model:FindFirstChild(part)
if limb then core[limb]=part end
end
r.att=X.findAtt(model,core)
for _,a in ipairs(r.att) do
if X.anch(a.part) then r.manual=true end
end
S.xrigs[#S.xrigs+1]=r
X.rebuildIds()
return true
end
function X.freeRig(r)
local an=r.model:FindFirstChild("Animate")
if an and r.animWas~=nil then an.Disabled=r.animWas end
if r.anchWas~=nil and r.hrp then pcall(function() r.hrp.Anchored=r.anchWas end) end
for k,pn in pairs(S.pins15) do if pn.r==r then S.pins15[k]=nil end end
if r.manual then X.place(r) end
end
function X.rebuildIds()
S.ids={}
for _,p in ipairs(PARTS) do S.ids[#S.ids+1]=p end
for _,id in ipairs(S.xids) do S.ids[#S.ids+1]=id end
end
function X.makeTrack(inst,kind,path)
local tf,ch
if inst then
local k
tf,ch,k=X.classInfo(inst)
kind=k
else
tf,ch=X.kindInfo(kind)
end
if not ch then return nil end
local ex=inst and S.xbyInst[inst]
if ex then return ex end
S.xn=S.xn+1
local id="x" .. S.xn
S.xmeta[id]={path=path or X.pathOf(inst),kind=kind,inst=inst,tf=tf,ch=ch}
if inst then S.xinit[id]=X.capture(inst,tf,ch) end
S.tracks[id]={}
S.xids[#S.xids+1]=id
if inst then S.xbyInst[inst]=id end
X.rebuildIds()
return id
end
function X.drop(id)
X.restore(id)
local mt=S.xmeta[id]
if mt and mt.inst then S.xbyInst[mt.inst]=nil end
for i,v in ipairs(S.xids) do
if v==id then table.remove(S.xids,i); break end
end
S.xmeta[id]=nil; S.xinit[id]=nil; S.tracks[id]=nil; S.pins[id]=nil
end
function X.clearAll()
X.restoreAll()
for _,r in ipairs(S.xrigs) do X.freeRig(r) end
S.xids={}; S.xmeta={}; S.xinit={}; S.xroots={}; S.xbyInst={}; S.xrigs={}; S.pins15={}
for k in pairs(S.pins) do if not S.motors[k] then S.pins[k]=nil end end
for k in pairs(S.tracks) do
if string.sub(k,1,1)=="x" then S.tracks[k]=nil end
end
X.rebuildIds()
end
function X.trackJ(id)
local m=S.motors[id]
if m then
local c0=S.c0 and S.c0[id]
if m.Part0 and c0 then return m.Part0.CFrame*c0 end
return nil
end
local mt,ini=S.xmeta[id],S.xinit[id]
if mt and mt.motor and ini and ini.c0 and mt.motor.Part0 then return mt.motor.Part0.CFrame*ini.c0 end
if mt and mt.tf and mt.inst and mt.inst.Parent and ini and ini.cf then
local par=mt.inst.Parent
if mt.inst:IsA("Attachment") and par and par:IsA("BasePart") then return par.CFrame*ini.cf end
return ini.cf
end
return nil
end
function X.sdBox(p,h)
local qx,qy,qz=math.abs(p.X) - h.X,math.abs(p.Y) - h.Y,math.abs(p.Z) - h.Z
if qx>0 or qy>0 or qz>0 then return math.max(qx,math.max(qy,qz)),nil end
if qx>=qy and qx>=qz then return qx,Vector3.new(p.X>=0 and 1 or -1,0,0) end
if qy>=qz then return qy,Vector3.new(0,p.Y>=0 and 1 or -1,0) end
return qz,Vector3.new(0,0,p.Z>=0 and 1 or -1)
end
function X.arc(a,b)
local c=math.clamp(a:Dot(b),-1,1)
local ax=a:Cross(b)
if ax.Magnitude<1e-6 then
if c>0 then return CFrame.new() end
local perp=a:Cross(Vector3.new(1,0,0))
if perp.Magnitude<1e-3 then perp=a:Cross(Vector3.new(0,1,0)) end
return CFrame.fromAxisAngle(perp.Unit,math.pi)
end
return CFrame.fromAxisAngle(ax.Unit,math.acos(c))
end
function X.limbInfo(id)
local m,c0,tm
if S.motors[id] then
if id=="Torso" then return nil end
m=S.motors[id]; c0=S.c0 and S.c0[id]; tm=S.motors.Torso
else
local mt=S.xmeta[id]
if not (mt and mt.motor and mt.part~="Torso" and mt.rig) then return nil end
m=mt.motor; c0=S.xinit[id] and S.xinit[id].c0; tm=mt.rig.motors.Torso
end
if not (m and c0 and tm and m.Part1 and tm.Part1 and m.Part1.Size and tm.Part1.Size) then return nil end
return m,c0,m.Part1.Size,tm.Part1.Size
end
function X.ikInfo(id)
local m,_,ls=X.limbInfo(id)
if not m then return nil end
local isHead=(id=="Head") or (S.xmeta[id] and S.xmeta[id].part=="Head")
local sy=ls.Y/2
return {C1i=m.C1:Inverse(),q=Vector3.new(0,isHead and sy or -sy,0)}
end
function X.anch(p)
local ok,r=pcall(function() return p.Anchored or (p.AssemblyRootPart and p.AssemblyRootPart.Anchored) end)
return ok and r and true or false
end
function X.findAtt(model,core)
local adj={}
local function link(a,b)
adj[a]=adj[a] or {}
table.insert(adj[a],b)
end
for _,d in ipairs(model:GetDescendants()) do
if d:IsA("JointInstance") or d:IsA("WeldConstraint") then
local a,b=d.Part0,d.Part1
if a and b and a:IsA("BasePart") and b:IsA("BasePart") then link(a,b); link(b,a) end
end
end
local out,seen={},{}
for limb,name in pairs(core) do
if name~="HumanoidRootPart" then
local q,qi={limb},1
while qi<=#q do
local cur=q[qi]; qi=qi+1
for _,nb in ipairs(adj[cur] or {}) do
if not core[nb] and not seen[nb] then
seen[nb]=true
out[#out+1]={part=nb,limb=name,off=limb.CFrame:Inverse()*nb.CFrame}
q[#q+1]=nb
end
end
end
end
end
return out
end
function X.attPlace(r)
if not (r and r.att and #r.att>0 and r.hrp) then return end
local mR=r.motors.Torso
if not mR then return end
local W={Torso=r.hrp.CFrame*mR.C0*mR.C1:Inverse()}
for _,part in ipairs(PARTS) do
if part~="Torso" and r.motors[part] then
local m=r.motors[part]
W[part]=W.Torso*m.C0*m.C1:Inverse()
end
end
for _,a in ipairs(r.att) do
local lw=W[a.limb]
if lw and a.part.Parent then pcall(function() a.part.CFrame=lw*a.off end) end
end
end
local function ensureZero()
for _,p in ipairs(S.ids) do
if not getKey(p,0) then
local k={f=0,px=0,py=0,pz=0,rx=0,ry=0,rz=0,e=S.ease,d=S.dir}
local ini=S.xinit[p]
if ini then for i,v in ipairs(ini.ch) do k["c" .. i]=v end end
table.insert(S.tracks[p],k)
sortT(S.tracks[p])
end
end
S.dirty=true
end
local function ensureKey(part,f)
local k=getKey(part,f)
if k then return k end
local cf=evalPart(part,f)
local rx,ry,rz=cf:ToEulerAnglesXYZ()
local p=cf.Position
k={f=f,px=p.X,py=p.Y,pz=p.Z,rx=math.deg(rx),ry=math.deg(ry),rz=math.deg(rz),e=S.ease,d=S.dir}
if S.xmeta[part] then
local c=X.evalChan(part,f)
for i,v in ipairs(c) do k["c" .. i]=v end
end
table.insert(S.tracks[part],k)
sortT(S.tracks[part])
return k
end
function X.ensureTrack(inst)
local id=X.makeTrack(inst)
if id and S.rig then ensureZero() end
return id
end
function X.addRoot(inst)
if inst==S.rig then return false end
for _,r in ipairs(S.xroots) do
if r.inst==inst then return false end
end
S.xroots[#S.xroots+1]={path=X.pathOf(inst),inst=inst}
local m=X.isR6(inst)
local l15=(not m) and X.isR15(inst)
if m and X.addRig(inst,m) then
if S.rig then ensureZero() end
elseif l15 and X.addRig15(inst,l15) then
ensureZero()
else
X.ensureTrack(inst)
end
return true
end
function X.removeRoot(inst)
local idx
for i,r in ipairs(S.xroots) do
if r.inst==inst then idx=i; break end
end
if not idx then return false end
local kill={}
for _,id in ipairs(S.xids) do
local i2=S.xmeta[id].inst
if i2 and (i2==inst or i2:IsDescendantOf(inst)) then kill[#kill+1]=id end
end
for _,id in ipairs(kill) do X.drop(id) end
for i=#S.xrigs,1,-1 do
if S.xrigs[i].model==inst then X.freeRig(S.xrigs[i]); table.remove(S.xrigs,i) end
end
table.remove(S.xroots,idx)
X.rebuildIds()
return true
end
local function manualPlace()
for _,part in ipairs(PARTS) do
local m=S.motors[part]
if m and m.Part0 and m.Part1 then
pcall(function() m.Part1.CFrame=m.Part0.CFrame*m.C0*m.C1:Inverse() end)
end
end
end
local function applyPose(f)
for part,m in pairs(S.motors) do
local c0=S.c0 and S.c0[part]
if c0 then pcall(function() m.C0=c0*evalPart(part,f) end) end
end
if S.manual then manualPlace() end
for _,id in ipairs(S.xids) do X.apply(id,f) end
for _,r in ipairs(S.xrigs) do
if r.manual then X.place(r) end
X.attPlace(r)
end
if S.attRig then X.attPlace(S.attRig) end
end
local function curF() return math.floor(S.cur+0.5) end
local function r3(v) return math.floor(v*1000+0.5)/1000 end
local function curVals()
local k=getKey(S.sel,curF())
if k then return k end
local cf=evalPart(S.sel,S.cur)
local rx,ry,rz=cf:ToEulerAnglesXYZ()
local p=cf.Position
return {rx=math.deg(rx),ry=math.deg(ry),rz=math.deg(rz),px=p.X,py=p.Y,pz=p.Z}
end
local function playEnd()
if S.endLast then
local m=0
for _,p in ipairs(S.ids) do
local t=S.tracks[p]
if #t>0 and t[#t].f>m then m=t[#t].f end
end
if m>0 then return m end
end
return S.len
end
local function copyTracks(src)
local o={}
for _,p in ipairs(S.ids) do
o[p]={}
for i,k in ipairs(src[p] or {}) do
local c={}
for kk,v in pairs(k) do c[kk]=v end
o[p][i]=c
end
end
return o
end
local undoS,redoS={},{}
local function pushUndo()
table.insert(undoS,copyTracks(S.tracks))
if #undoS>60 then table.remove(undoS,1) end
redoS={}
S.dirty=true
end
local function serialize()
local tr={}
for _,p in ipairs(PARTS) do
tr[p]={}
for i,k in ipairs(S.tracks[p]) do
tr[p][i]={f=k.f,px=k.px,py=k.py,pz=k.pz,rx=k.rx,ry=k.ry,rz=k.rz,e=k.e,d=k.d}
end
end
local xs,xr={},{}
for _,id in ipairs(S.xids) do
local mt=S.xmeta[id]
local ks={}
for i,k in ipairs(S.tracks[id]) do
ks[i]={f=k.f,px=k.px,py=k.py,pz=k.pz,rx=k.rx,ry=k.ry,rz=k.rz,c1=k.c1,c2=k.c2,c3=k.c3,e=k.e,d=k.d}
end
xs[#xs+1]={path=mt.path,kind=mt.kind,keys=ks}
end
for _,r in ipairs(S.xroots) do xr[#xr+1]={path=r.path} end
return {name=S.name,fps=S.fps,len=S.len,loop=S.loop,prio=S.prio,tracks=tr,xs=xs,xr=xr}
end
local function deserialize(d)
S.name=tostring(d.name or "Importada")
S.fps=math.clamp(tonumber(d.fps) or 30,1,120)
S.len=math.clamp(tonumber(d.len) or 60,10,2000)
S.loop=d.loop~=false
S.prio=({Idle=1,Movement=1,Action=1,Core=1})[d.prio] and d.prio or "Action"
for _,p in ipairs(PARTS) do
S.tracks[p]={}
for _,k in ipairs((d.tracks and d.tracks[p]) or {}) do
table.insert(S.tracks[p],{
f=tonumber(k.f) or 0,px=tonumber(k.px) or 0,py=tonumber(k.py) or 0,pz=tonumber(k.pz) or 0,
rx=tonumber(k.rx) or 0,ry=tonumber(k.ry) or 0,rz=tonumber(k.rz) or 0,
e=EASES[table.find(EASES,k.e) or 1],d=DIRS[table.find(DIRS,k.d) or 1],
})
end
sortT(S.tracks[p])
end
X.clearAll()
S.xmode=false; S.xrow0=1; S.sel="Torso"; S.pins={}; S.pins15={}
for _,r in ipairs(d.xr or {}) do
if type(r)=="table" and type(r.path)=="table" then
local ri=X.resolve(r.path)
S.xroots[#S.xroots+1]={path=r.path,inst=ri}
if ri and ri~=S.rig and X.isR6(ri) then X.addRig(ri) end
end
end
for _,e in ipairs(d.xs or {}) do
if type(e)=="table" and type(e.path)=="table" and type(e.keys)=="table" then
local id=X.makeTrack(X.resolve(e.path),e.kind,e.path)
if id then
for _,k in ipairs(e.keys) do
table.insert(S.tracks[id],{
f=tonumber(k.f) or 0,px=tonumber(k.px) or 0,py=tonumber(k.py) or 0,pz=tonumber(k.pz) or 0,
rx=tonumber(k.rx) or 0,ry=tonumber(k.ry) or 0,rz=tonumber(k.rz) or 0,
c1=tonumber(k.c1),c2=tonumber(k.c2),c3=tonumber(k.c3),
e=EASES[table.find(EASES,k.e) or 1],d=DIRS[table.find(DIRS,k.d) or 1],
})
end
sortT(S.tracks[id])
end
end
end
S.selKey=nil; S.selSet={}; S.cur=0; S.playing=false
undoS,redoS={},{}
if S.rig then ensureZero() end
if X.refreshBtns then X.refreshBtns() end
end
local reg,strokes,conns={},{},{}
local moveCB,endCB={},{}
local toast,rebuildTL,refreshProps,setFrame,updatePlayhead,rebuildFilesList
local dropdown,closeDD,showPanel,setPicking
local playBtn,easeBtn,dirBtn,TL,timeLbl,INFO,PH,KNOB,rigChip,UISC,gradient
local SP,FP,BOT,NAMES,W,selB,selE
local mini,picking=false,false
local updateGizmo,refreshGizmoBtns,nameBox,jsonBox,bClose
local function isPress(i) return i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 end
local function isMove(i) return i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement end
S.T={
en={
["Arquivo"]="File",
["Editar"]="Edit",
["Opções"]="Options",
["Copiar"]="Copy",
["Colar"]="Paste",
["Apagar"]="Delete",
["Nova animação"]="New animation",
["Salvar"]="Save",
["Abrir / Importar..."]="Open / Import...",
["Copiar JSON"]="Copy JSON",
["Exportar KeyframeSequence"]="Export KeyframeSequence",
["Importar KeyframeSequence..."]="Import KeyframeSequence...",
["Restaurar autosave"]="Restore autosave",
["Desfazer"]="Undo",
["Refazer"]="Redo",
["Copiar keyframes/pose"]="Copy keyframes/pose",
["Colar keyframes/pose"]="Paste keyframes/pose",
["Limpar trilha selecionada"]="Clear selected track",
["Limpar tudo"]="Clear all",
["Adicionar na trilha"]="Add to track",
["Adicionar em todas"]="Add to all tracks",
["Apagar selecionados"]="Delete selected",
["Remover de todas (frame atual)"]="Remove from all (current frame)",
["Mover keyframe  <  1 frame"]="Move keyframe  <  1 frame",
["Mover keyframe  >  1 frame"]="Move keyframe  >  1 frame",
["Zerar pose"]="Reset pose",
["Aplicar easing em toda a trilha"]="Apply easing to the whole track",
["Select KFs (ligar/desligar)"]="Select KFs (on/off)",
["Selecionar todos"]="Select all",
["Selecionar trilha atual"]="Select current track",
["Limpar seleção"]="Clear selection",
["Duplicar seleção à direita"]="Duplicate selection to the right",
["Selecionar rig (tocar no NPC)"]="Select rig (tap the NPC)",
["Configurações..."]="Settings...",
["Soltar rig"]="Release rig",
["Soltar rig atual"]="Release current rig",
["CONFIGURAÇÕES"]="SETTINGS",
["Fechar"]="Close",
["Transparência"]="Transparency",
["Tamanho"]="Size",
["Largura"]="Width",
["Altura"]="Height",
["Tema"]="Theme",
["Paleta"]="Palette",
["KF sel."]="Sel. KF",
["Ancorar rig"]="Anchor rig",
["Autosave"]="Autosave",
["Forçar pose"]="Force pose",
["Fim=último KF"]="End=last KF",
["Travar KF 0"]="Lock KF 0",
["Imagem de fundo (ID)"]="Background image (ID)",
["Aplicar"]="Apply",
["Remover"]="Remove",
["Mover"]="Move",
["Girar"]="Rotate",
["Eixos"]="Axes",
["Mundo"]="World",
["Valores (Part/VFX)"]="Values (Part/VFX)",
["Explorar"]="Browse",
["Meus"]="Mine",
["Por ID"]="By ID",
["Atualizar"]="Refresh",
["Buscar"]="Search",
["Pública"]="Public",
["Privada"]="Private",
["Público"]="Public",
["Privado"]="Private",
["Publicar"]="Publish",
["Copiar ID"]="Copy ID",
["Nome"]="Name",
["Visibilidade"]="Visibility",
["Digite o ID único (ex: #AE0F62O) e toque em Buscar"]="Enter the unique ID (e.g. #AE0F62O) and tap Search",
["Nenhuma animação pública ainda"]="No public animations yet",
["Você ainda não publicou nada"]="You haven't published anything yet",
["Salve uma animação primeiro (Arquivo)"]="Save an animation first (File)",
["Publicando..."]="Publishing...",
["Publicada (pública)!"]="Published (public)!",
["Publicada (privada)!"]="Published (private)!",
["Publicada"]="Published",
["# animação(ões) pública(s)"]="# public animation(s)",
["# upload(s)"]="# upload(s)",
["Escolha uma animação salva na lista"]="Pick a saved animation from the list",
["Selecione uma animação na lista"]="Select an animation in the list",
["Busque um ID primeiro"]="Search for an ID first",
["Publique primeiro"]="Publish first",
["ID inválido"]="Invalid ID",
["Animação não encontrada"]="Animation not found",
["Dados inválidos"]="Invalid data",
["Animação grande demais"]="Animation too large",
["Firebase bloqueou (confira as Rules do banco)"]="Firebase blocked the request (check the database Rules)",
["Sem conexão (URL errada ou request bloqueado)"]="No connection (wrong URL or request blocked)",
["Falha HTTP #"]="HTTP failure #",
["Não consegui gerar um ID único"]="Could not generate a unique ID",
["Removida da sua lista (o servidor mantém a publicação)"]="Removed from your list (the server keeps the post)",
["Apagada"]="Deleted",
["Inserida"]="Inserted",
["ID copiado"]="ID copied",
["modo local (só neste aparelho)"]="local mode (this device only)",
["servidor"]="server",
["ARQUIVOS  |  conta"]="FILES  |  account",
["Exportar KFS"]="Export KFS",
["Importar"]="Import",
["Cole aqui o JSON de uma animação"]="Paste an animation JSON here",
["Nenhuma animação salva ainda"]="No saved animations yet",
["Abrir"]="Open",
["Salvas"]="Saved",
["arquivo"]="file",
["memória"]="memory",
["Prioridade"]="Priority",
["Assado (= Play)"]="Baked (= Play)",
["Só keyframes"]="Keyframes only",
["Export"]="Export",
["Salvo"]="Saved",
["Aberta"]="Opened",
["Animacao importada"]="Animation imported",
["JSON copiado"]="JSON copied",
["JSON invalido"]="Invalid JSON",
["Sem clipboard: JSON na caixa"]="No clipboard: JSON is in the box",
["Sem clipboard: JSON na caixa abaixo"]="No clipboard: JSON is in the box below",
["Nova animacao"]="New animation",
["Autosave restaurado"]="Autosave restored",
["Nenhum autosave"]="No autosave",
["Keyframes apagados (o KF 0 fica)"]="Keyframes deleted (KF 0 stays)",
["# keyframe(s) apagado(s)"]="# keyframe(s) deleted",
["# keyframe(s) colado(s)"]="# keyframe(s) pasted",
["# keyframe(s) copiado(s)"]="# keyframe(s) copied",
["# selecionado(s)"]="# selected",
["Pose copiada"]="Pose copied",
["Nada copiado"]="Nothing copied",
["Nada para desfazer"]="Nothing to undo",
["Nada para refazer"]="Nothing to redo",
["Nada para exportar (sem keyframes)"]="Nothing to export (no keyframes)",
["Nada encontrado"]="Nothing found",
["Nenhum keyframe selecionado"]="No keyframe selected",
["Escolha um rig primeiro (Select ou Rig)"]="Pick a rig first (Select or Rig)",
["Selecione um item da lista"]="Select an item from the list",
["Selecione um keyframe (toque no losango)"]="Select a keyframe (tap the diamond)",
["KF 0 é a posição inicial (travado)"]="KF 0 is the initial pose (locked)",
["KF 0 é a posição inicial (travado). Destrave em Config"]="KF 0 is the initial pose (locked). Unlock it in Settings",
["Sem keyframe aqui: use +KF"]="No keyframe here: use +KF",
["Sem keyframe neste frame: use +KF"]="No keyframe on this frame: use +KF",
["Sem keyframe aqui: o easing vira o padrão dos novos keyframes"]="No keyframe here: the easing becomes the default for new keyframes",
["Só há 1 keyframe nesta trilha: nada para suavizar"]="Only 1 keyframe on this track: nothing to ease",
["Easing aplicado (# trecho(s))"]="Easing applied (# segment(s))",
["último keyframe: aplicado no trecho que chega nele (# trecho(s))"]="last keyframe: applied to the segment that arrives at it (# segment(s))",
["Selecione keyframes (Select KFs)"]="Select keyframes (Select KFs)",
["Toque em Select e depois no NPC R6 que quer animar"]="Tap Select and then the R6 NPC you want to animate",
["Toque no NPC R6 que você quer animar"]="Tap the R6 NPC you want to animate",
["Nada ali. Toque no NPC R6"]="Nothing there. Tap the R6 NPC",
["Isso não é um personagem/NPC"]="That is not a character/NPC",
["Esse modelo não é R6"]="This model is not R6",
["Nenhum rig R6 encontrado"]="No R6 rig found",
["Não é R6: falta "]="Not R6: missing ",
["Rig carregado"]="Rig loaded",
["Rig solto"]="Rig released",
["sem rig (toque em Select)"]="no rig (tap Select)",
["Second Anim: toque em + para abrir os filhos; toque no nome para animar"]="Second Anim: tap + to open children; tap a name to animate",
["Voltou para o rig"]="Back to the rig",
["Esse item não é animável (Part, Attachment, Beam, Trail, Particle, Luz, Fire, Smoke, Decal)"]="This item cannot be animated (Part, Attachment, Beam, Trail, Particle, Light, Fire, Smoke, Decal)",
["Selecione um item com valores (Part, Beam, luz...)"]="Select an item with values (Part, Beam, light...)",
["Valores no frame "]="Values on frame ",
["Aplicar neste frame"]="Apply on this frame",
["Cancelar"]="Cancel",
["Toque num item e em Add"]="Tap an item and then Add",
["Selecione um item na lista"]="Select an item in the list",
["Selecionado"]="Selected",
["Adicionado! Use o botão Second Anim"]="Added! Use the Second Anim button",
["Já está no Second Anim"]="Already in Second Anim",
["Esse item não é uma raiz adicionada"]="This item is not an added root",
["Selecione a raiz adicionada"]="Select the added root",
["Removido (valores restaurados)"]="Removed (values restored)",
["buscar por nome/classe (ex: Beam)"]="search by name/class (e.g. Beam)",
["# KeyframeSequence criada(s) (assada: igual ao Play)"]="# KeyframeSequence created (baked: same as Play)",
["# KeyframeSequence criada(s) (só os keyframes)"]="# KeyframeSequence created (keyframes only)",
["Erro"]="Error",
["Idioma"]="Language",
["IMPORTAR KEYFRAMESEQUENCE"]="IMPORT KEYFRAMESEQUENCE",
["Importar no rig"]="Import into rig",
["Só salvar"]="Save only",
["Escaneando o jogo..."]="Scanning the game...",
["# KeyframeSequence encontrada(s)"]="# KeyframeSequence found",
["Selecione uma KeyframeSequence na lista"]="Select a KeyframeSequence in the list",
["Nenhum membro R6 nessa animação (R15?)"]="No R6 limbs in this animation (R15?)",
["Importada (a anterior ficou no autosave)"]="Imported (the previous one is in autosave)",
["Salva na lista de salvas"]="Saved to the saved list",
["buscar KeyframeSequence..."]="search KeyframeSequence...",
["Fundo aplicado (use o ID da IMAGEM, não do decal)"]="Background applied (use the IMAGE ID, not the decal ID)",
["Fundo removido"]="Background removed",
["Seu executor não tem função request"]="Your executor has no request function"
},
es={
["Arquivo"]="Archivo",
["Editar"]="Editar",
["Opções"]="Opciones",
["Copiar"]="Copiar",
["Colar"]="Pegar",
["Apagar"]="Borrar",
["Nova animação"]="Nueva animación",
["Salvar"]="Guardar",
["Abrir / Importar..."]="Abrir / Importar...",
["Copiar JSON"]="Copiar JSON",
["Exportar KeyframeSequence"]="Exportar KeyframeSequence",
["Importar KeyframeSequence..."]="Importar KeyframeSequence...",
["Restaurar autosave"]="Restaurar autoguardado",
["Desfazer"]="Deshacer",
["Refazer"]="Rehacer",
["Copiar keyframes/pose"]="Copiar keyframes/pose",
["Colar keyframes/pose"]="Pegar keyframes/pose",
["Limpar trilha selecionada"]="Limpiar pista seleccionada",
["Limpar tudo"]="Limpiar todo",
["Adicionar na trilha"]="Añadir en la pista",
["Adicionar em todas"]="Añadir en todas",
["Apagar selecionados"]="Borrar seleccionados",
["Remover de todas (frame atual)"]="Quitar de todas (fotograma actual)",
["Mover keyframe  <  1 frame"]="Mover keyframe  <  1 fotograma",
["Mover keyframe  >  1 frame"]="Mover keyframe  >  1 fotograma",
["Zerar pose"]="Reiniciar pose",
["Aplicar easing em toda a trilha"]="Aplicar easing a toda la pista",
["Select KFs (ligar/desligar)"]="Select KFs (activar/desactivar)",
["Selecionar todos"]="Seleccionar todos",
["Selecionar trilha atual"]="Seleccionar pista actual",
["Limpar seleção"]="Limpiar selección",
["Duplicar seleção à direita"]="Duplicar selección a la derecha",
["Selecionar rig (tocar no NPC)"]="Seleccionar rig (tocar el NPC)",
["Configurações..."]="Ajustes...",
["Soltar rig"]="Soltar rig",
["Soltar rig atual"]="Soltar rig actual",
["CONFIGURAÇÕES"]="AJUSTES",
["Fechar"]="Cerrar",
["Transparência"]="Transparencia",
["Tamanho"]="Tamaño",
["Largura"]="Ancho",
["Altura"]="Alto",
["Tema"]="Tema",
["Paleta"]="Paleta",
["KF sel."]="KF sel.",
["Ancorar rig"]="Anclar rig",
["Autosave"]="Autoguardado",
["Forçar pose"]="Forzar pose",
["Fim=último KF"]="Fin=último KF",
["Travar KF 0"]="Bloquear KF 0",
["Imagem de fundo (ID)"]="Imagen de fondo (ID)",
["Aplicar"]="Aplicar",
["Remover"]="Quitar",
["Mover"]="Mover",
["Girar"]="Girar",
["Eixos"]="Ejes",
["Mundo"]="Mundo",
["Valores (Part/VFX)"]="Valores (Part/VFX)",
["Explorar"]="Explorar",
["Meus"]="Mis subidas",
["Por ID"]="Por ID",
["Atualizar"]="Actualizar",
["Buscar"]="Buscar",
["Pública"]="Pública",
["Privada"]="Privada",
["Público"]="Público",
["Privado"]="Privado",
["Publicar"]="Publicar",
["Copiar ID"]="Copiar ID",
["Nome"]="Nombre",
["Visibilidade"]="Visibilidad",
["Digite o ID único (ex: #AE0F62O) e toque em Buscar"]="Escribe el ID único (ej: #AE0F62O) y toca Buscar",
["Nenhuma animação pública ainda"]="Aún no hay animaciones públicas",
["Você ainda não publicou nada"]="Aún no has publicado nada",
["Salve uma animação primeiro (Arquivo)"]="Guarda una animación primero (Archivo)",
["Publicando..."]="Publicando...",
["Publicada (pública)!"]="¡Publicada (pública)!",
["Publicada (privada)!"]="¡Publicada (privada)!",
["Publicada"]="Publicada",
["# animação(ões) pública(s)"]="# animación(es) pública(s)",
["# upload(s)"]="# subida(s)",
["Escolha uma animação salva na lista"]="Elige una animación guardada de la lista",
["Selecione uma animação na lista"]="Selecciona una animación en la lista",
["Busque um ID primeiro"]="Busca un ID primero",
["Publique primeiro"]="Publica primero",
["ID inválido"]="ID inválido",
["Animação não encontrada"]="Animación no encontrada",
["Dados inválidos"]="Datos inválidos",
["Animação grande demais"]="Animación demasiado grande",
["Firebase bloqueou (confira as Rules do banco)"]="Firebase bloqueó la solicitud (revisa las Rules)",
["Sem conexão (URL errada ou request bloqueado)"]="Sin conexión (URL incorrecta o request bloqueado)",
["Falha HTTP #"]="Fallo HTTP #",
["Não consegui gerar um ID único"]="No pude generar un ID único",
["Removida da sua lista (o servidor mantém a publicação)"]="Quitada de tu lista (el servidor mantiene la publicación)",
["Apagada"]="Borrada",
["Inserida"]="Insertada",
["ID copiado"]="ID copiado",
["modo local (só neste aparelho)"]="modo local (solo en este dispositivo)",
["servidor"]="servidor",
["ARQUIVOS  |  conta"]="ARCHIVOS  |  cuenta",
["Exportar KFS"]="Exportar KFS",
["Importar"]="Importar",
["Cole aqui o JSON de uma animação"]="Pega aquí el JSON de una animación",
["Nenhuma animação salva ainda"]="Aún no hay animaciones guardadas",
["Abrir"]="Abrir",
["Salvas"]="Guardadas",
["arquivo"]="archivo",
["memória"]="memoria",
["Prioridade"]="Prioridad",
["Assado (= Play)"]="Horneado (= Play)",
["Só keyframes"]="Solo keyframes",
["Export"]="Exportar",
["Salvo"]="Guardado",
["Aberta"]="Abierta",
["Animacao importada"]="Animación importada",
["JSON copiado"]="JSON copiado",
["JSON invalido"]="JSON inválido",
["Sem clipboard: JSON na caixa"]="Sin portapapeles: JSON en la caja",
["Sem clipboard: JSON na caixa abaixo"]="Sin portapapeles: JSON en la caja de abajo",
["Nova animacao"]="Nueva animación",
["Autosave restaurado"]="Autoguardado restaurado",
["Nenhum autosave"]="Sin autoguardado",
["Keyframes apagados (o KF 0 fica)"]="Keyframes borrados (el KF 0 se queda)",
["# keyframe(s) apagado(s)"]="# keyframe(s) borrado(s)",
["# keyframe(s) colado(s)"]="# keyframe(s) pegado(s)",
["# keyframe(s) copiado(s)"]="# keyframe(s) copiado(s)",
["# selecionado(s)"]="# seleccionado(s)",
["Pose copiada"]="Pose copiada",
["Nada copiado"]="Nada copiado",
["Nada para desfazer"]="Nada que deshacer",
["Nada para refazer"]="Nada que rehacer",
["Nada para exportar (sem keyframes)"]="Nada que exportar (sin keyframes)",
["Nada encontrado"]="No se encontró nada",
["Nenhum keyframe selecionado"]="Ningún keyframe seleccionado",
["Escolha um rig primeiro (Select ou Rig)"]="Elige un rig primero (Select o Rig)",
["Selecione um item da lista"]="Selecciona un elemento de la lista",
["Selecione um keyframe (toque no losango)"]="Selecciona un keyframe (toca el rombo)",
["KF 0 é a posição inicial (travado)"]="KF 0 es la pose inicial (bloqueado)",
["KF 0 é a posição inicial (travado). Destrave em Config"]="KF 0 es la pose inicial (bloqueado). Desbloquéalo en Ajustes",
["Sem keyframe aqui: use +KF"]="Sin keyframe aquí: usa +KF",
["Sem keyframe neste frame: use +KF"]="Sin keyframe en este fotograma: usa +KF",
["Sem keyframe aqui: o easing vira o padrão dos novos keyframes"]="Sin keyframe aquí: el easing pasa a ser el predeterminado",
["Só há 1 keyframe nesta trilha: nada para suavizar"]="Solo hay 1 keyframe en esta pista: nada que suavizar",
["Easing aplicado (# trecho(s))"]="Easing aplicado (# tramo(s))",
["último keyframe: aplicado no trecho que chega nele (# trecho(s))"]="último keyframe: aplicado al tramo que llega a él (# tramo(s))",
["Selecione keyframes (Select KFs)"]="Selecciona keyframes (Select KFs)",
["Toque em Select e depois no NPC R6 que quer animar"]="Toca Select y luego el NPC R6 que quieres animar",
["Toque no NPC R6 que você quer animar"]="Toca el NPC R6 que quieres animar",
["Nada ali. Toque no NPC R6"]="Nada ahí. Toca el NPC R6",
["Isso não é um personagem/NPC"]="Eso no es un personaje/NPC",
["Esse modelo não é R6"]="Este modelo no es R6",
["Nenhum rig R6 encontrado"]="No se encontró ningún rig R6",
["Não é R6: falta "]="No es R6: falta ",
["Rig carregado"]="Rig cargado",
["Rig solto"]="Rig soltado",
["sem rig (toque em Select)"]="sin rig (toca Select)",
["Second Anim: toque em + para abrir os filhos; toque no nome para animar"]="Second Anim: toca + para abrir los hijos; toca el nombre para animar",
["Voltou para o rig"]="Volvió al rig",
["Esse item não é animável (Part, Attachment, Beam, Trail, Particle, Luz, Fire, Smoke, Decal)"]="Este elemento no se puede animar (Part, Attachment, Beam, Trail, Particle, Luz, Fire, Smoke, Decal)",
["Selecione um item com valores (Part, Beam, luz...)"]="Selecciona un elemento con valores (Part, Beam, luz...)",
["Valores no frame "]="Valores en el fotograma ",
["Aplicar neste frame"]="Aplicar en este fotograma",
["Cancelar"]="Cancelar",
["Toque num item e em Add"]="Toca un elemento y luego Add",
["Selecione um item na lista"]="Selecciona un elemento en la lista",
["Selecionado"]="Seleccionado",
["Adicionado! Use o botão Second Anim"]="¡Añadido! Usa el botón Second Anim",
["Já está no Second Anim"]="Ya está en Second Anim",
["Esse item não é uma raiz adicionada"]="Este elemento no es una raíz añadida",
["Selecione a raiz adicionada"]="Selecciona la raíz añadida",
["Removido (valores restaurados)"]="Quitado (valores restaurados)",
["buscar por nome/classe (ex: Beam)"]="buscar por nombre/clase (ej: Beam)",
["# KeyframeSequence criada(s) (assada: igual ao Play)"]="# KeyframeSequence creada(s) (horneada: igual al Play)",
["# KeyframeSequence criada(s) (só os keyframes)"]="# KeyframeSequence creada(s) (solo los keyframes)",
["Erro"]="Error",
["Idioma"]="Idioma",
["IMPORTAR KEYFRAMESEQUENCE"]="IMPORTAR KEYFRAMESEQUENCE",
["Importar no rig"]="Importar en el rig",
["Só salvar"]="Solo guardar",
["Escaneando o jogo..."]="Escaneando el juego...",
["# KeyframeSequence encontrada(s)"]="# KeyframeSequence encontrada(s)",
["Selecione uma KeyframeSequence na lista"]="Selecciona una KeyframeSequence en la lista",
["Nenhum membro R6 nessa animação (R15?)"]="Ningún miembro R6 en esta animación (¿R15?)",
["Importada (a anterior ficou no autosave)"]="Importada (la anterior quedó en el autoguardado)",
["Salva na lista de salvas"]="Guardada en la lista de guardadas",
["buscar KeyframeSequence..."]="buscar KeyframeSequence...",
["Fundo aplicado (use o ID da IMAGEM, não do decal)"]="Fondo aplicado (usa el ID de la IMAGEN, no del decal)",
["Fundo removido"]="Fondo quitado",
["Seu executor não tem função request"]="Tu executor no tiene la función request"
},
["pt-PT"]={
["Arquivo"]="Ficheiro",
["Apagar"]="Eliminar",
["Salvar"]="Guardar",
["Restaurar autosave"]="Restaurar cópia automática",
["Apagar selecionados"]="Eliminar selecionados",
["Soltar rig"]="Largar rig",
["Soltar rig atual"]="Largar rig atual",
["Autosave"]="Cópia auto.",
["Girar"]="Rodar",
["Salve uma animação primeiro (Arquivo)"]="Guarde uma animação primeiro (Ficheiro)",
["Escolha uma animação salva na lista"]="Escolha uma animação guardada na lista",
["Apagada"]="Eliminada",
["ARQUIVOS  |  conta"]="FICHEIROS  |  conta",
["Nenhuma animação salva ainda"]="Nenhuma animação guardada ainda",
["arquivo"]="ficheiro",
["Autosave restaurado"]="Cópia automática restaurada",
["Nenhum autosave"]="Sem cópia automática",
["Keyframes apagados (o KF 0 fica)"]="Keyframes eliminados (o KF 0 fica)",
["# keyframe(s) apagado(s)"]="# keyframe(s) eliminado(s)",
["Rig solto"]="Rig largado",
["Só salvar"]="Só guardar",
["Importada (a anterior ficou no autosave)"]="Importada (a anterior ficou na cópia automática)",
["Salva na lista de salvas"]="Guardada na lista de guardadas"
},
}
local function L(s,lang)
lang=lang or S.lang
if type(s)~="string" or lang=="pt-BR" then return s end
local d=S.T[lang]
if not d then return s end
local v=d[s]
if v then return v end
local nums={}
for n in s:gmatch("%d+") do nums[#nums+1]=n end
if #nums>0 then
local key=(s:gsub("%d+","#"))
local v2=d[key]
if v2 then
local i=0
return (v2:gsub("#",function() i=i+1; return nums[i] or "#" end))
end
end
local a,b=s:match("^(.-): (.+)$")
if a and d[a] then return d[a] .. ": " .. L(b,lang) end
for k,tv in pairs(d) do
if #k>2 and k:sub(-1)==" " and s:sub(1,#k)==k then return tv .. s:sub(#k+1) end
end
if S.audit then S.miss[s]=true end
return s
end
S.L=L
local function addTr(k,en,es,pt)
S.T.en[k]=en; S.T.es[k]=es
if pt then S.T["pt-PT"][k]=pt end
end
addTr("Confirmar","Confirm","Confirmar")
addTr("Valores","Values","Valores")
addTr("IK desligado","IK off","IK desactivado")
addTr("Ponta travada no lugar. Mexa ou gire o torso: o membro se inclina","Tip pinned. Move or rotate the torso: the limb tilts","Punta fijada. Mueve o gira el torso: el miembro se inclina")
addTr("Ponta solta","Tip released","Punta suelta")
addTr("Ponta travada. Mexa o torso: o membro dobra e a ponta fica no lugar","Tip pinned. Move the torso: the limb bends and the tip stays put","Punta fijada. Mueve el torso: el miembro se dobla y la punta se queda")
addTr("Animação de R15: escolha um rig R15 como alvo","R15 animation: pick an R15 rig as the target","Animación R15: elige un rig R15 como destino")
addTr("Esse item não tem ponta para travar","This item has no tip to pin","Este elemento no tiene punta para fijar")
addTr("Sem atravessar o corpo: ligado","Body collision: on","Sin atravesar el cuerpo: activado")
addTr("Sem atravessar o corpo: desligado","Body collision: off","Sin atravesar el cuerpo: desactivado")
addTr("Assada: igual ao Play (60 Hz)","Baked: same as Play (60 Hz)","Horneada: igual al Play (60 Hz)")
addTr("Só os keyframes","Keyframes only","Solo los keyframes")
addTr("  Rig alvo","  Target rig","  Rig de destino")
addTr("(nenhum)","(none)","(ninguno)")
addTr("Adicionada ao rig (toca em loop ao entrar no jogo)","Added to the rig (plays in a loop when the game starts)","Añadida al rig (se reproduce en bucle al entrar al juego)")
addTr("Adicionada! Script copiado: cole num Script dentro do rig","Added! Script copied: paste it into a Script inside the rig","¡Añadida! Script copiado: pégalo en un Script dentro del rig")
addTr("Esse rig R15 não tem as juntas esperadas","This R15 rig does not have the expected joints","Este rig R15 no tiene las articulaciones esperadas")
S.setT=function(o,txt) S.orig[o]=txt; o.Text=L(txt) end
S.setPh=function(o,txt) S.origPh[o]=txt; o.PlaceholderText=L(txt) end
S.relang=function()
for o,t in pairs(S.orig) do
if o.Parent then o.Text=L(t) end
end
for o,t in pairs(S.origPh) do
if o.Parent then o.PlaceholderText=L(t) end
end
end
local function new(class,props,parent)
local o=Instance.new(class)
if o:IsA("GuiObject") then o.BorderSizePixel=0 end
if o:IsA("GuiButton") then o.AutoButtonColor=false end
for k,v in pairs(props) do o[k]=v end
if class~="TextBox" and type(props.Text)=="string" and L(props.Text,"en")~=props.Text then
S.orig[o]=props.Text; o.Text=L(props.Text)
end
if type(props.PlaceholderText)=="string" and L(props.PlaceholderText,"en")~=props.PlaceholderText then
S.origPh[o]=props.PlaceholderText; o.PlaceholderText=L(props.PlaceholderText)
end
o.Parent=parent
return o
end
local function round(o,r) return new("UICorner",{CornerRadius=UDim.new(0,r or 5)},o) end
local function paint(o,bgk,base,tk)
local e={o,bgk,base or 0,tk}
reg[#reg+1]=e
return e
end
local function applyStyle()
local t=TH()
for _,r in ipairs(reg) do
local o=r[1]
if o.Parent then
if r[2] then o.BackgroundColor3=t[r[2]] end
local tr=A(r[3])
if S.ghost and o==SP then tr=0.94 end
o.BackgroundTransparency=tr
if r[4] then o.TextColor3=t[r[4]] end
end
end
for _,s in ipairs(strokes) do s.Color=t.accent end
if gradient then gradient.Color=ColorSequence.new(t.accent,t.accent2) end
end
local function tap(obj,fn,noActivated)
local last,start,id=0,nil,nil
local function fire(pos)
local n=os.clock()
if n - last<0.15 then return end
last=n
local ok,err=pcall(fn,pos)
if not ok then
warn("[Hax Animator] " .. tostring(err))
if toast then toast("Erro: " .. string.sub(tostring(err),1,90),true) end
end
end
obj.InputBegan:Connect(function(i)
if isPress(i) then
start=i.Position; id=i
if not S.cal then
local ap,az=obj.AbsolutePosition,obj.AbsoluteSize
local x,y=i.Position.X,i.Position.Y
local insY=game:GetService("GuiService"):GetGuiInset().Y
local ok0=x>=ap.X and x<=ap.X+az.X and y>=ap.Y and y<=ap.Y+az.Y
local ok1=x>=ap.X and x<=ap.X+az.X and y - insY>=ap.Y and y - insY<=ap.Y+az.Y
if ok0 and not ok1 then S.cal=true; S.posOff=V2(0,0)
elseif ok1 and not ok0 then S.cal=true; S.posOff=V2(0,insY) end
end
end
end)
obj.InputEnded:Connect(function(i)
if i==id then
id=nil
if start and (i.Position - start).Magnitude<14 then fire(i.Position) end
end
end)
if not noActivated and obj:IsA("GuiButton") then
obj.Activated:Connect(function() fire(nil) end)
end
end
local function lbl(parent,text,x,y,w,h,size,bold,ck)
local l=new("TextLabel",{
Text=text,Position=UO(x,y),Size=UO(w,h or 20),
[BT]=1,Font=bold and FT.GothamBold or FT.Gotham,
TextSize=size or 11,TextXAlignment=XL,
},parent)
paint(l,nil,1,ck or "text")
return l
end
local function btn(parent,text,x,y,w,h,cb,style,font,size)
local b=new("TextButton",{
Text=text,Position=UO(x,y),Size=UO(w,h),
Font=font or FT.GothamBold,TextSize=size or 11,
},parent)
local key=style or "bg3"
local e=paint(b,key,0,key=="accent" and "ttext" or "text")
round(b,5)
tap(b,cb)
b.InputBegan:Connect(function(i) if isPress(i) then b.BackgroundColor3=TH().accent2 end end)
b.InputEnded:Connect(function(i) if isPress(i) then b.BackgroundColor3=TH()[e[2]] end end)
return b,e
end
local function setOn(b,e,on)
e[2]=on and "accent" or "bg3"
e[4]=on and "ttext" or "text"
b.BackgroundColor3=TH()[e[2]]
b.TextColor3=TH()[e[4]]
end
local function tbox(parent,text,x,y,w,cb)
local b=new("TextBox",{
Text=text,Position=UO(x,y),Size=UO(w,20),
Font=FT.Gotham,TextSize=11,ClearTextOnFocus=false,
},parent)
paint(b,"bg3",0,"text")
round(b,5)
b.FocusLost:Connect(function() cb(b.Text,b) end)
return b
end
local function slider(parent,pos,size,min,max,init,cb,opts)
opts=opts or {}
local lmin,lmax=math.log(min),math.log(max)
local function toA(v)
if opts.log then return (math.log(v) - lmin)/(lmax - lmin) end
return (v - min)/(max - min)
end
local function fromA(a)
if opts.log then return math.exp(lmin+(lmax - lmin)*a) end
return min+(max - min)*a
end
local bar=new("Frame",{Position=pos,Size=size,Active=true},parent)
paint(bar,"bg3"); round(bar,7)
local fill=new("Frame",{Size=UN(math.clamp(toA(init),0,1),0,1,0)},bar)
paint(fill,"accent"); round(fill,7)
local on,inp=false,nil
local function upd(px)
local a=math.clamp((px - bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
fill.Size=UN(a,0,1,0)
cb(fromA(a))
end
bar.InputBegan:Connect(function(i)
if isPress(i) then
on=true; inp=i
if opts.onStart then opts.onStart() end
upd(i.Position.X)
end
end)
moveCB[#moveCB+1]=function(i)
if on and (i==inp or i.UserInputType==Enum.UserInputType.MouseMovement) then upd(i.Position.X) end
end
endCB[#endCB+1]=function()
if on then
on=false
if opts.onEnd then opts.onEnd() end
end
end
return function(v) fill.Size=UN(math.clamp(toA(v),0,1),0,1,0) end
end
local gui=Instance.new("ScreenGui")
gui.Name="HaxAnimator"; gui.ResetOnSpawn=false; gui.DisplayOrder=999; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local okp=pcall(function() gui.Parent=(gethui and gethui()) or game:GetService("CoreGui") end)
if not okp or not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end
local GZ=new("Frame",{Name="Gizmo",Size=UDim2.fromScale(1,1),[BT]=1,Active=false},gui)
W=new("Frame",{
Name="Window",Size=UO(WIN_W,WIN_H),Position=UO(10,36),
ClipsDescendants=true,Active=true,
},gui)
paint(W,"bg"); round(W,6)
strokes[#strokes+1]=new("UIStroke",{Thickness=2,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},W)
UISC=new("UIScale",{Scale=S.scale},W)
S.BG=new("ImageLabel",{Size=UN(1,0,1,0),[BT]=1,Image="",ImageTransparency=0.12,ScaleType=Enum.ScaleType.Crop,ZIndex=0,Visible=false},W)
S.applyBg=function()
if S.bgId~="" then S.BG.Image="rbxassetid://" .. S.bgId; S.BG.Visible=true else S.BG.Visible=false end
applyStyle(); rebuildTL()
end
do
local TBAR=new("Frame",{Size=UN(1,0,0,TITLE_H),[BC]=Color3.new(1,1,1),Active=true},W)
paint(TBAR,nil,0)
gradient=new("UIGradient",{Color=ColorSequence.new(TH().accent,TH().accent2),Rotation=0},TBAR)
local logo=new("Frame",{Size=UO(9,9),Position=UO(10,6),Rotation=45},TBAR)
paint(logo,"ttext")
local ttl=new("TextLabel",{
Position=UO(26,0),Size=UO(110,TITLE_H),[BT]=1,
Text="HAX ANIMATOR",Font=FT.GothamBlack,TextSize=12,TextXAlignment=XL,
},TBAR)
paint(ttl,nil,1,"ttext")
local ver=new("TextLabel",{
Position=UO(122,0),Size=UO(40,TITLE_H),[BT]=1,
Text="R6/R15 v3.9.3",Font=FT.GothamMedium,TextSize=10,TextXAlignment=XL,TextTransparency=0.25,
},TBAR)
paint(ver,nil,1,"ttext")
rigChip=new("TextLabel",{
Position=UN(1,-250,0,0),Size=UO(200,TITLE_H),[BT]=1,
Text="sem rig",Font=FT.GothamMedium,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,
},TBAR)
paint(rigChip,nil,1,"ttext")
local bMin=new("TextButton",{Text="-",Position=UN(1,-46,0,0),Size=UO(22,TITLE_H),[BT]=1,Font=FT.GothamBlack,TextSize=15},TBAR)
paint(bMin,nil,1,"ttext")
bClose=new("TextButton",{Text="X",Position=UN(1,-24,0,0),Size=UO(22,TITLE_H),[BT]=1,Font=FT.GothamBlack,TextSize=12},TBAR)
paint(bClose,nil,1,"ttext")
local dragW
TBAR.InputBegan:Connect(function(i) if isPress(i) then dragW={i.Position,W.Position,i} end end)
moveCB[#moveCB+1]=function(i)
if dragW and (i==dragW[3] or i.UserInputType==Enum.UserInputType.MouseMovement) then
local d=i.Position - dragW[1]
W.Position=UN(dragW[2].X.Scale,dragW[2].X.Offset+d.X,dragW[2].Y.Scale,dragW[2].Y.Offset+d.Y)
end
end
endCB[#endCB+1]=function() dragW=nil end
tap(bMin,function()
mini=not mini
W.Size=mini and UO(WIN_W,TITLE_H) or UO(WIN_W,WIN_H)
end)
end
local MENUBAR=new("Frame",{Position=UO(0,TITLE_H),Size=UN(1,0,0,MENU_H)},W)
paint(MENUBAR,"bg")
local TOOLBAR=new("Frame",{Position=UO(0,TITLE_H+MENU_H),Size=UN(1,0,0,TOOL_H)},W)
paint(TOOLBAR,"bg2")
NAMES=new("Frame",{Position=UO(0,BODY_Y),Size=UO(NAMES_W,BODY_H+4),ClipsDescendants=true},W)
paint(NAMES,"bg2")
TL=new("ScrollingFrame",{
Position=UO(NAMES_W,BODY_Y),Size=UN(1,-NAMES_W,0,BODY_H+4),
ScrollBarThickness=3,ScrollingDirection=Enum.ScrollingDirection.X,CanvasSize=UN(),
ElasticBehavior=Enum.ElasticBehavior.Never,
},W)
paint(TL,"bg")
local DYN=new("Frame",{Size=UO(100,BODY_H),[BT]=1},TL)
PH=new("Frame",{Size=UO(2,BODY_H),[BC]=RGB(80,160,255),ZIndex=8},TL)
KNOB=new("Frame",{Size=UO(12,12),[BC]=RGB(80,160,255),ZIndex=9},TL)
round(KNOB,6)
new("UIStroke",{Color=Color3.new(1,1,1),Thickness=1.5},KNOB)
INFO=new("TextLabel",{
Position=UO(0,INFO_Y),Size=UN(1,0,0,16),Text="",
Font=FT.GothamMedium,TextSize=10,TextXAlignment=XL,
},W)
paint(INFO,"bg3",0,"sub")
new("UIPadding",{PaddingLeft=UDim.new(0,8)},INFO)
BOT=new("Frame",{Position=UO(0,INFO_Y+16),Size=UN(1,0,0,48),[BT]=1},W)
S.syncPanels=function()
local any=false
for _,pp in ipairs(S.panels) do
if pp.Visible then any=true end
end
for _,o in ipairs({MENUBAR,TOOLBAR,NAMES,TL,INFO,BOT}) do o.Visible=not any end
end
S.reg=function(pp)
S.panels[#S.panels+1]=pp
pp:GetPropertyChangedSignal("Visible"):Connect(S.syncPanels)
end
local function applyLayout()
calcDims()
W.Size=mini and UO(WIN_W,TITLE_H) or UO(WIN_W,WIN_H)
NAMES.Size=UO(NAMES_W,BODY_H+4)
TL.Size=UN(1,-NAMES_W,0,BODY_H+4)
PH.Size=UO(2,BODY_H)
INFO.Position=UO(0,INFO_Y)
BOT.Position=UO(0,INFO_Y+16)
end
local scrub,keyDrag=false,nil
local rowDrag=nil
local lastTap={part=nil,t=0,f=-1}
local function xOf(f) return PAD+f*S.ppf end
local function xToFrame(px)
local rel=(px - TL.AbsolutePosition.X)/UISC.Scale+TL.CanvasPosition.X - PAD
return math.clamp(math.floor(rel/S.ppf+0.5),0,S.len)
end
local function selectKey(part,k)
S.sel=part; S.selKey=k; S.selSet={[k]=true}
S.ease,S.dir=k.e,k.d
if easeBtn then easeBtn.Text=k.e end
if dirBtn then dirBtn.Text=k.d end
end
local function selList()
local out={}
for _,p in ipairs(S.ids) do
for _,k in ipairs(S.tracks[p]) do
if S.selSet[k] then out[#out+1]={p=p,k=k} end
end
end
return out
end
local function toggleKey(part,k)
S.sel=part
if S.selSet[k] then
S.selSet[k]=nil
if S.selKey==k then S.selKey=next(S.selSet) end
else
S.selSet[k]=true; S.selKey=k
end
end
local function selectTrack(part)
if S.sel~=part then S.sel=part; S.selKey=nil end
rebuildTL(); refreshProps()
end
moveCB[#moveCB+1]=function(i)
if scrub then setFrame(xToFrame(i.Position.X)) end
if keyDrag then
if math.abs(i.Position.X - keyDrag.x0)>6 then keyDrag.moved=true end
if keyDrag.moved then
local nf=xToFrame(i.Position.X)
if nf~=keyDrag.k.f and not getKey(keyDrag.part,nf) then
if not keyDrag.pushed then pushUndo(); keyDrag.pushed=true end
keyDrag.k.f=nf
sortT(S.tracks[keyDrag.part])
rebuildTL()
setFrame(nf)
end
end
end
end
endCB[#endCB+1]=function() scrub=false; keyDrag=nil; TL.ScrollingEnabled=true end
local function setPlaying(on)
if on then
if S.cur>=playEnd() then S.cur=0 end
S.playing=true; playBtn.Text="II"
else
S.playing=false; S.cur=curF(); playBtn.Text="►"
applyPose(S.cur)
end
updatePlayhead(); refreshProps()
end
local ACT={}
local function needRig()
if S.rig or #S.xrigs>0 then return false end
toast("Escolha um rig primeiro (Select ou Rig)",true)
return true
end
local function locked(k) return S.lock0 and k.f==0 end
local function needSel()
if needRig() then return true end
if (S.xmeta[S.sel]~=nil)~=S.xmode then toast("Selecione um item da lista",true); return true end
return false
end
function ACT.addKeyAt(f)
if needSel() then return end
pushUndo()
selectKey(S.sel,ensureKey(S.sel,f))
rebuildTL(); refreshProps()
end
function ACT.addKey() ACT.addKeyAt(curF()) end
function ACT.addAll()
if needRig() then return end
pushUndo()
for _,p in ipairs(S.xmode and S.xids or PARTS) do ensureKey(p,curF()) end
local kk=getKey(S.sel,curF())
if kk then selectKey(S.sel,kk) end
rebuildTL(); refreshProps()
end
function ACT.delKey()
if needRig() then return end
local L=selList()
if #L>0 then
pushUndo()
local n,skip=0,0
for _,it in ipairs(L) do
if locked(it.k) then skip=skip+1
else
local idx=table.find(S.tracks[it.p],it.k)
if idx then table.remove(S.tracks[it.p],idx); n=n+1 end
end
end
S.selKey=nil; S.selSet={}
rebuildTL(); applyPose(S.cur); refreshProps()
toast(n .. " keyframe(s) apagado(s)" .. (skip>0 and " (KF 0 é a posição inicial: travado)" or ""),n==0)
return
end
local k=getKey(S.sel,curF())
if k and locked(k) then toast("KF 0 é a posição inicial (travado)",true); return end
local tr=S.tracks[S.sel]
local idx=k and table.find(tr,k)
if idx then
pushUndo(); table.remove(tr,idx); S.selKey=nil
rebuildTL(); applyPose(S.cur); refreshProps()
else
toast("Nenhum keyframe selecionado",true)
end
end
function ACT.delAll()
if needRig() then return end
pushUndo()
for _,p in ipairs(S.ids) do
local k=getKey(p,curF())
local idx=k and not locked(k) and table.find(S.tracks[p],k)
if idx then table.remove(S.tracks[p],idx) end
end
S.selKey=nil; S.selSet={}; rebuildTL(); applyPose(S.cur); refreshProps()
end
function ACT.moveKey(d)
if needSel() then return end
local k=S.selKey
if not k then toast("Selecione um keyframe (toque no losango)",true); return end
if locked(k) then toast("KF 0 é a posição inicial (travado)",true); return end
local nf=k.f+d
if nf<0 or nf>S.len or getKey(S.sel,nf) then return end
pushUndo(); k.f=nf; sortT(S.tracks[S.sel])
rebuildTL(); setFrame(nf)
end
function ACT.copy()
local L=selList()
if #L==0 then
local k=getKey(S.sel,curF())
if k then L={{p=S.sel,k=k}} end
end
if #L>0 then
local base=L[1].k.f
for _,it in ipairs(L) do base=math.min(base,it.k.f) end
local items={}
for _,it in ipairs(L) do
local c={}
for kk,v in pairs(it.k) do c[kk]=v end
c.p=it.p; c.f=it.k.f - base
items[#items+1]=c
end
S.kfClip={items=items}
toast(#items .. " keyframe(s) copiado(s)")
return
end
local v=curVals()
S.clip={px=v.px,py=v.py,pz=v.pz,rx=v.rx,ry=v.ry,rz=v.rz}
toast("Pose copiada")
end
function ACT.paste(at)
if needRig() then return end
local c=S.kfClip
if c then
pushUndo()
local base=type(at)=="number" and at or curF()
local single=(#c.items==1)
if single and ((S.xmeta[S.sel]~=nil)~=S.xmode) then toast("Selecione um item da lista",true); return end
local newSel,maxF={},0
for _,it in ipairs(c.items) do
local part=single and S.sel or it.p
local f=base+it.f
if f<=2000 then
local k=getKey(part,f)
if not (k and locked(k)) then
if not k then k={f=f}; table.insert(S.tracks[part],k) end
for _,fld in ipairs({"px","py","pz","rx","ry","rz","e","d"}) do k[fld]=it[fld] end
newSel[k]=true
maxF=math.max(maxF,f)
end
end
end
for _,p in ipairs(S.ids) do sortT(S.tracks[p]) end
if maxF>S.len then S.len=maxF end
S.selSet=newSel; S.selKey=next(newSel)
applyPose(S.cur); rebuildTL(); refreshProps(); toast(#c.items .. " keyframe(s) colado(s)")
return
end
if not S.clip then toast("Nada copiado",true); return end
pushUndo()
local k=ensureKey(S.sel,curF())
for key,val in pairs(S.clip) do k[key]=val end
selectKey(S.sel,k); applyPose(S.cur); rebuildTL(); refreshProps()
end
function ACT.dup()
if needRig() then return end
local L=selList()
if #L==0 then toast("Selecione keyframes (Select KFs)",true); return end
ACT.copy()
local base,mx=L[1].k.f,0
for _,it in ipairs(L) do base=math.min(base,it.k.f) end
for _,it in ipairs(S.kfClip.items) do mx=math.max(mx,it.f) end
ACT.paste(base+(mx>0 and mx or 1))
end
function ACT.selAll(onlyTrack)
S.selSet={}; S.selKey=nil
for _,p in ipairs(S.ids) do
if not onlyTrack or p==S.sel then
for _,k in ipairs(S.tracks[p]) do S.selSet[k]=true; S.selKey=k end
end
end
rebuildTL(); refreshProps(); toast(#selList() .. " selecionado(s)")
end
function ACT.selNone()
S.selSet={}; S.selKey=nil; rebuildTL(); refreshProps()
end
function ACT.toggleSel()
S.selMode=not S.selMode
if S.selMode and S.cfgMode then S.cfgMode=false; if S.cfgBtn then setOn(S.cfgBtn[1],S.cfgBtn[2],false) end end
if S.selBtn then setOn(S.selBtn[1],S.selBtn[2],S.selMode) end
toast(S.selMode and "Select KFs: toque nos losangos (toque no nome da trilha = trilha toda)" or "Select KFs desligado")
end
function ACT.toggleTrack(part)
S.sel=part
local all=#S.tracks[part]>0
for _,k in ipairs(S.tracks[part]) do if not S.selSet[k] then all=false end end
for _,k in ipairs(S.tracks[part]) do S.selSet[k]=(not all) or nil end
S.selKey=next(S.selSet)
rebuildTL(); refreshProps()
end
function ACT.zero()
if needSel() then return end
pushUndo()
local k=ensureKey(S.sel,curF())
k.px,k.py,k.pz,k.rx,k.ry,k.rz=0,0,0,0,0,0
selectKey(S.sel,k); applyPose(S.cur); rebuildTL(); refreshProps()
end
function ACT.easeAll()
if needSel() then return end
pushUndo()
for _,k in ipairs(S.tracks[S.sel]) do k.e=S.ease; k.d=S.dir end
applyPose(S.cur); toast("Easing aplicado na trilha")
end
function ACT.clearTrack()
if needSel() then return end
pushUndo(); S.tracks[S.sel]={}; S.selKey=nil; S.selSet={}; ensureZero()
rebuildTL(); applyPose(S.cur); refreshProps()
end
function ACT.clearAll()
if needRig() then return end
pushUndo()
for _,p in ipairs(S.ids) do S.tracks[p]={} end
S.selKey=nil; S.selSet={}; ensureZero(); rebuildTL(); applyPose(S.cur); refreshProps(); toast("Keyframes apagados (o KF 0 fica)")
end
function ACT.undo()
if needRig() then return end
if #undoS==0 then toast("Nada para desfazer",true); return end
table.insert(redoS,copyTracks(S.tracks))
S.tracks=table.remove(undoS); S.selKey=nil; S.selSet={}; S.dirty=true
for _,p in ipairs(S.ids) do S.tracks[p]=S.tracks[p] or {} end
ensureZero()
rebuildTL(); applyPose(S.cur); refreshProps()
end
function ACT.redo()
if needRig() then return end
if #redoS==0 then toast("Nada para refazer",true); return end
table.insert(undoS,copyTracks(S.tracks))
S.tracks=table.remove(redoS); S.selKey=nil; S.selSet={}; S.dirty=true
for _,p in ipairs(S.ids) do S.tracks[p]=S.tracks[p] or {} end
ensureZero()
rebuildTL(); applyPose(S.cur); refreshProps()
end
function ACT.new()
if needRig() then return end
pushUndo()
for _,p in ipairs(PARTS) do S.tracks[p]={} end
X.clearAll(); S.xmode=false; S.xrow0=1; S.sel="Torso"; S.pins={}; S.pins15={}
S.selKey=nil; S.selSet={}; S.cur=0; S.name="Anim" .. tostring(math.random(100,999)); ensureZero()
rebuildTL(); applyPose(0); refreshProps(); toast("Nova animacao")
end
local function stopTracks()
for _,r in ipairs(S.xrigs) do
local h2=r.model:FindFirstChildOfClass("Humanoid")
local a2=h2 and h2:FindFirstChildOfClass("Animator")
if a2 then
for _,tr in ipairs(a2:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
end
end
if not S.rig then return end
local hum=S.rig:FindFirstChildOfClass("Humanoid")
local an=hum and hum:FindFirstChildOfClass("Animator")
if an then
for _,tr in ipairs(an:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
end
end
local function applyAnchor()
if not S.rig then return end
local hrp=S.rig:FindFirstChild("HumanoidRootPart")
if not hrp then return end
if S.anchor then
if S.anchWas==nil then S.anchWas=hrp.Anchored end
hrp.Anchored=true
elseif S.anchWas~=nil then
hrp.Anchored=S.anchWas; S.anchWas=nil
end
end
local function setHighlight(model)
if S.hl then pcall(function() S.hl:Destroy() end); S.hl=nil end
if model then
pcall(function()
local h=Instance.new("Highlight")
h.Adornee=model; h.FillTransparency=1
h.OutlineColor=TH().accent; h.OutlineTransparency=0.1
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.Parent=model
S.hl=h
end)
end
end
local function releaseRig()
X.restoreAll()
if S.rig then
for part,m in pairs(S.motors) do pcall(function() m.C0=S.c0[part]; m.Transform=CFrame.new() end) end
if S.manual then manualPlace() end
if S.attRig then X.attPlace(S.attRig) end
local an=S.rig:FindFirstChild("Animate")
if an and S.animWas~=nil then an.Disabled=S.animWas end
local hrp=S.rig:FindFirstChild("HumanoidRootPart")
if hrp and S.anchWas~=nil then hrp.Anchored=S.anchWas end
end
setHighlight(nil)
S.rig=nil; S.motors={}; S.c0=nil; S.manual=false; S.att=nil; S.attRig=nil; S.anchWas=nil; S.animWas=nil
end
local function loadRig(model)
local hrp=model:FindFirstChild("HumanoidRootPart")
local hum=model:FindFirstChildOfClass("Humanoid")
local l15=hrp and hum and not model:FindFirstChild("Torso") and X.isR15(model)
if l15 then
for _,r in ipairs(S.xrigs) do
if r.model==model then toast("Rig R15 já adicionado: use Second Anim"); return true end
end
if not X.addRoot(model) then toast("Não deu para adicionar o rig R15",true); return false end
S.xmode=true; S.xrow0=1; S.xopen[model]=true
for _,r in ipairs(S.xrigs) do
if r.model==model and r.rootName then S.sel=r.ids[r.rootName] end
end
X.refreshBtns(); stopTracks(); applyPose(S.cur); setHighlight(model)
rebuildTL(); refreshProps()
toast("Rig R15 carregado: " .. model.Name .. ". Toque nas partes (UpperArm, Foot...) para animar")
return true
end
if not (hrp and hum and model:FindFirstChild("Torso")) then toast("Esse modelo não é R6",true); return false end
local motors={}
for part,info in pairs(MOTOR) do
local holder=model:FindFirstChild(info[1])
local m=holder and holder:FindFirstChild(info[2])
if not (m and m:IsA("Motor6D")) then toast("Não é R6: falta " .. info[2],true); return false end
motors[part]=m
end
releaseRig()
S.xmode=false; S.xrow0=1; S.selKey=nil
if S.xmeta[S.sel] then S.sel="Torso" end
S.rig=model; S.motors=motors
S.c0={}
for part,m in pairs(motors) do
S.c0[part]=m.C0
pcall(function() m.Transform=CFrame.new() end)
end
S.manual=false
local core={[hrp]="HumanoidRootPart"}
for _,p in ipairs(PARTS) do
local pt=model:FindFirstChild(p)
if pt then core[pt]=p end
if pt and X.anch(pt) then S.manual=true end
end
S.att=X.findAtt(model,core)
S.attRig={hrp=hrp,motors=motors,att=S.att}
for _,a in ipairs(S.att) do
if X.anch(a.part) then S.manual=true end
end
local an=model:FindFirstChild("Animate")
S.animWas=an and an.Disabled
if an then an.Disabled=true end
ensureZero()
stopTracks(); applyAnchor(); applyPose(S.cur); setHighlight(model)
rebuildTL()
refreshProps()
toast("Rig carregado: " .. model.Name)
return true
end
local function findRigs()
local list={}
for _,d in ipairs(workspace:GetDescendants()) do
if d:IsA("Model") and d:FindFirstChild("HumanoidRootPart") and d:FindFirstChildOfClass("Humanoid") and ((d:FindFirstChild("Torso") and d:FindFirstChild("Left Arm")) or (d:FindFirstChild("UpperTorso") and d:FindFirstChild("LeftUpperArm"))) then
list[#list+1]=d
if #list>=40 then break end
end
end
return list
end
setPicking=function(on)
picking=on
if selB then setOn(selB,selE,on) end
if on then toast("Toque no NPC R6 que você quer animar") else refreshProps() end
end
local function onWorldTap(x,y)
local cam=workspace.CurrentCamera
if not cam then return end
if os.clock()-(S.lastDragT or 0)<0.4 then return end
local ray=cam:ScreenPointToRay(x,y)
local res=workspace:Raycast(ray.Origin,ray.Direction*2000)
if picking then
local okp,rp=pcall(function()
local q=RaycastParams.new()
q.FilterType=Enum.RaycastFilterType.Exclude
q.FilterDescendantsInstances={LP.Character}
return q
end)
if okp and rp then res=workspace:Raycast(ray.Origin,ray.Direction*2000,rp) end
if not res then toast("Nada ali. Toque no NPC R6",true); return end
local m=res.Instance:FindFirstAncestorOfClass("Model")
while m and not m:FindFirstChildOfClass("Humanoid") do m=m:FindFirstAncestorOfClass("Model") end
if not m then toast("Isso não é um personagem/NPC",true); return end
if loadRig(m) then setPicking(false) end
elseif res and S.rig and res.Instance:IsDescendantOf(S.rig) then
local nm=res.Instance.Name
if nm=="HumanoidRootPart" then nm="Torso" end
if S.tracks[nm] then selectTrack(nm) end
elseif res then
for _,r in ipairs(S.xrigs) do
if r.kind=="R15" and res.Instance:IsDescendantOf(r.model) then
local id=S.xbyInst[res.Instance]
if id then S.xmode=true; selectTrack(id); rebuildTL() end
break
end
end
end
end
local EXPORT_STYLE={Linear="Linear",Constant="Constant",Elastic="Elastic",Bounce="Bounce"}
local EXPORT_DIR={In="Out",Out="In",InOut="InOut"}
local function exportOne(ids,name)
local frames,any={},false
for _,p in ipairs(PARTS) do
for _,k in ipairs(S.tracks[ids[p]]) do frames[k.f]=true; any=true end
end
if not any then return false end
local list={}
if S.expBake then
local dur=playEnd()/S.fps
local n=math.ceil(dur*60 - 1e-9)
for i=0,n - 1 do list[#list+1]=(i/60)*S.fps end
list[#list+1]=dur*S.fps
else
for f in pairs(frames) do list[#list+1]=f end
table.sort(list)
end
local ks=Instance.new("KeyframeSequence")
ks.Name=name; ks.Loop=S.loop
pcall(function() ks.Priority=Enum.AnimationPriority[S.prio] end)
for _,f in ipairs(list) do
local kf=Instance.new("Keyframe")
kf.Time=f/S.fps
local function mk(part,parent)
local p=Instance.new("Pose")
p.Name=part
local k=getKey(ids[part],f)
if S.expBake then
p.CFrame=evalPart(ids[part],f); p.Weight=1
pcall(function() p.EasingStyle=Enum.PoseEasingStyle.Linear; p.EasingDirection=Enum.PoseEasingDirection.Out end)
elseif k then
p.CFrame=keyCF(k); p.Weight=1
pcall(function()
local es=EXPORT_STYLE[k.e]
if es then p.EasingStyle=Enum.PoseEasingStyle[es]
elseif not pcall(function() p.EasingStyle=Enum.PoseEasingStyle.CubicV2 end) then p.EasingStyle=Enum.PoseEasingStyle.Cubic end
p.EasingDirection=Enum.PoseEasingDirection[EXPORT_DIR[k.d] or "Out"]
end)
else
p.Weight=0
end
p.Parent=parent
return p
end
local root=Instance.new("Pose"); root.Name="HumanoidRootPart"; root.Weight=0; root.Parent=kf
local torso=mk("Torso",root)
for _,limb in ipairs({"Head","Right Arm","Left Arm","Right Leg","Left Leg"}) do mk(limb,torso) end
kf.Parent=ks
end
ks.Parent=workspace
return ks
end
local function doExport()
local ids={}
for _,p in ipairs(PARTS) do ids[p]=p end
local n=0
local mainKs=exportOne(ids,S.name)
if mainKs then n=n+1 end
local r15ks
local byModel={}
for _,r in ipairs(S.xrigs) do
if r.kind=="R15" then
local k15=X.exportR15(r,S.name .. "_" .. r.model.Name)
if k15 then n=n+1; r15ks=r15ks or k15; byModel[r.model]=k15 end
else
local moves=false
for _,p in ipairs(PARTS) do
if #S.tracks[r.ids[p]]>1 then moves=true end
end
if moves and exportOne(r.ids,S.name .. "_" .. r.model.Name) then n=n+1 end
end
end
if n==0 then toast("Nada para exportar (sem keyframes)",true)
else toast(n .. " KeyframeSequence criada(s) (" .. (S.expBake and "assada: igual ao Play" or "só os keyframes") .. ")") end
if mainKs then return mainKs,false,byModel end
return r15ks,r15ks~=nil,byModel
end
S.doExport=doExport
function X.rows()
local out={}
if not S.xmode then
if not S.rig then return out end
for _,pp in ipairs(PARTS) do out[#out+1]={id=pp,label=pp,depth=0} end
return out
end
local function add(inst,depth)
if #out>=300 then return end
local ok,kids=pcall(function() return inst:GetChildren() end)
if not ok then kids={} end
local _,ch=X.classInfo(inst)
local r15
for _,r in ipairs(S.xrigs) do if r.kind=="R15" and r.model==inst then r15=r end end
out[#out+1]={id=S.xbyInst[inst],inst=inst,label=inst.Name,depth=depth,kids=#kids>0 or r15~=nil,open=S.xopen[inst]==true,anim=ch~=nil}
if S.xopen[inst] and depth<10 then
if r15 then
for _,nm in ipairs(r15.order) do
out[#out+1]={id=r15.ids[nm],inst=r15.motors[nm].Part1,label=nm,depth=depth+1,anim=true}
end
else
for _,c in ipairs(kids) do add(c,depth+1) end
end
end
end
for _,r in ipairs(S.xroots) do
if r.inst and r.inst.Parent then add(r.inst,0)
else out[#out+1]={label=(r.path[#r.path] or "?") .. " (?)",depth=0} end
end
return out
end
rebuildTL=function()
local t=TH()
DYN:ClearAllChildren()
NAMES:ClearAllChildren()
local cw=PAD*2+S.len*S.ppf+20
TL.CanvasSize=UO(cw,0)
DYN.Size=UO(cw,BODY_H)
timeLbl=new("TextLabel",{
Size=UO(NAMES_W,RULER),[BC]=t.bg3,[BT]=A(0),
Font=FT.GothamBold,TextSize=10,TextColor3=t.text,Text="",
},NAMES)
local ruler=new("Frame",{Size=UO(cw,RULER),[BC]=t.bg3,[BT]=A(0),Active=true,ZIndex=2},DYN)
ruler.InputBegan:Connect(function(i)
if isPress(i) then
if S.playing then setPlaying(false) end
scrub=true; TL.ScrollingEnabled=false
setFrame(xToFrame(i.Position.X))
end
end)
local step=math.max(1,math.ceil(34/S.ppf/5)*5)
for f=0,S.len,step do
new("TextLabel",{
Position=UO(xOf(f)+3,0),Size=UO(30,RULER),[BT]=1,
Text=tostring(f),Font=FT.Gotham,TextSize=9,TextColor3=t.sub,TextXAlignment=XL,ZIndex=3,
},DYN)
new("Frame",{
Position=UO(xOf(f),0),Size=UO(1,BODY_H),[BC]=t.line,
[BT]=A(0.35),ZIndex=2,
},DYN)
end
new("Frame",{
Position=UO(xOf(S.len),0),Size=UO(2,BODY_H),[BC]=t.accent2,
[BT]=A(0),ZIndex=4,
},DYN)
local rows=X.rows()
local first=1
if S.xmode then
first=math.max(1,math.min(S.xrow0,math.max(1,#rows - 5)))
S.xrow0=first
if #rows>6 then
timeLbl.Size=UO(NAMES_W - 56,RULER)
local up=new("TextButton",{Position=UO(NAMES_W - 56,0),Size=UO(28,RULER),Text="^^",Font=FT.GothamBold,TextSize=11,[BC]=t.accent,TextColor3=t.ttext},NAMES)
local dn=new("TextButton",{Position=UO(NAMES_W - 28,0),Size=UO(28,RULER),Text="vv",Font=FT.GothamBold,TextSize=11,[BC]=t.accent,TextColor3=t.ttext},NAMES)
tap(up,function() S.xrow0=math.max(1,S.xrow0 - 3); rebuildTL() end)
tap(dn,function() S.xrow0=S.xrow0+3; rebuildTL() end)
end
end
local isX=S.xmode
for idx=1,6 do
local row0=rows[first+idx - 1]
if not row0 then break end
local part=row0.id
local depth=row0.depth or 0
local y=RULER+(idx - 1)*ROW
local selected=part~=nil and part==S.sel
local nb=new("TextButton",{
Position=UO(0,y),Size=UO(NAMES_W,ROW),
[BC]=selected and t.accent2 or ((idx % 2==0) and t.bg3 or t.bg2),[BT]=A(selected and 0 or 0.35),
Text=isX and row0.label or ("      " .. row0.label),Font=selected and FT.GothamBold or FT.GothamMedium,TextSize=isX and 10 or 11,
TextColor3=selected and t.text or ((part or not isX or row0.anim) and t.sub or Color3.fromRGB(105,110,130)),TextXAlignment=XL,TextTruncate=Enum.TextTruncate.AtEnd,
},NAMES)
if isX then new("UIPadding",{PaddingLeft=UDim.new(0,28+depth*8)},nb) end
local dot=new("Frame",{
Position=UO(isX and (17+depth*8) or 9,y+ROW/2 - 3),Size=UO(6,6),
[BC]=part and (#S.tracks[part]>0) and t.accent or t.line,ZIndex=2,
},NAMES)
round(dot,3)
if selected then new("Frame",{Size=UO(3,ROW),Position=UO(0,y),[BC]=t.accent,ZIndex=2},NAMES) end
if #rows>6 then
nb.InputBegan:Connect(function(i)
if isPress(i) then rowDrag={y0=i.Position.Y,r0=S.xrow0,n=#rows} end
end)
end
if isX and row0.kids then
local ab=new("TextButton",{Position=UO(3+depth*8,y+3),Size=UO(14,ROW - 6),Text=row0.open and "-" or "+",Font=FT.GothamBold,TextSize=11,[BC]=t.bg3,TextColor3=t.text,ZIndex=3},NAMES)
tap(ab,function() S.xopen[row0.inst]=(not S.xopen[row0.inst]) or nil; rebuildTL() end)
end
tap(nb,function()
if not isX then
if S.selMode then ACT.toggleTrack(part) else selectTrack(part) end
return
end
local id=part
if not id and row0.inst then
if needRig() then return end
id=X.ensureTrack(row0.inst)
if not id then toast("Esse item não é animável (Part, Attachment, Beam, Trail, Particle, Luz, Fire, Smoke, Decal)",true); return end
end
if id then
if S.selMode then ACT.toggleTrack(id) else selectTrack(id) end
end
end)
local row=new("TextButton",{
Position=UO(0,y),Size=UO(cw,ROW),Text="",
[BC]=selected and t.accent or ((idx % 2==0) and t.bg2 or t.bg),
[BT]=A(selected and 0.86 or 0.1),ZIndex=1,
},DYN)
tap(row,function(pos)
if not part then
if pos then setFrame(xToFrame(pos.X)) end
return
end
if S.sel~=part then S.sel=part; S.selKey=nil end
if S.playing then setPlaying(false) end
local f=pos and xToFrame(pos.X) or curF()
local now=os.clock()
local dbl=lastTap.part==part and now - lastTap.t<0.4 and lastTap.f==f
lastTap={part=part,t=now,f=f}
if dbl then
S.cur=f; ACT.addKeyAt(f); setFrame(f)
else
setFrame(f); rebuildTL()
end
end,true)
if part then
new("Frame",{
Position=UO(PAD,y+ROW/2 - 1),Size=UO(S.len*S.ppf,2),[BC]=t.line,
[BT]=A(0),ZIndex=3,
},DYN)
for _,k in ipairs(S.tracks[part]) do
local isSel=S.selSet[k] or S.selKey==k
local sz=isSel and 13 or 11
local d=new("TextButton",{
Text="",Size=UO(sz,sz),AnchorPoint=AP5,
Position=UO(xOf(k.f),y+ROW/2),Rotation=45,
[BC]=isSel and S.kfSel or S.kfColor,ZIndex=isSel and 7 or 6,
},DYN)
new("UIStroke",{Color=Color3.new(0,0,0),Thickness=isSel and 1.5 or 1,Transparency=isSel and 0.2 or 0.5},d)
tap(d,function()
if S.selMode then toggleKey(part,k); rebuildTL(); refreshProps()
elseif S.cfgMode then X.openCfgKF(part,k) end
end)
d.InputBegan:Connect(function(i)
if isPress(i) and not S.selMode then
TL.ScrollingEnabled=false
if (S.rig or #S.xrigs>0) and not locked(k) then keyDrag={k=k,part=part,x0=i.Position.X,moved=false,pushed=false} end
if S.playing then setPlaying(false) end
if S.cfgMode and S.selSet[k] and #selList()>1 then
S.selKey=k; S.sel=part
else selectKey(part,k) end
rebuildTL()
setFrame(k.f)
if S.cfgMode then keyDrag=nil; TL.ScrollingEnabled=true; X.openCfgKF(part,k) end
end
end)
end
end
end
updatePlayhead()
if X.refreshBtns then X.refreshBtns() end
end
updatePlayhead=function()
local x=xOf(S.cur)
PH.Position=UO(x - 1,0)
KNOB.Position=UO(x - 6,2)
if timeLbl then timeLbl.Text=S.xmode and string.format("%df/%d",math.floor(S.cur+0.5),S.len) or string.format("%df/%d | %dfps",math.floor(S.cur+0.5),S.len,S.fps) end
end
setFrame=function(f)
S.cur=math.clamp(math.floor(f+0.5),0,S.len)
updatePlayhead(); applyPose(S.cur); refreshProps()
end
local toastId=0
refreshProps=function()
local f=curF()
local k=getKey(S.sel,f)
local v=curVals()
INFO.TextColor3=TH().sub
local mt=S.xmeta[S.sel]
local nm=mt and (mt.rig and (mt.rig.model.Name .. "." .. mt.part) or ((mt.inst and mt.inst.Name) or "?")) or S.sel
INFO.Text=string.format("%s | f%d/%d%s | P %.2f %.2f %.2f | R %.0f %.0f %.0f",nm,f,S.len,k and " KF" or "",v.px,v.py,v.pz,v.rx,v.ry,v.rz)
local nsel=#selList()
if nsel>0 then INFO.Text=INFO.Text .. " | SEL " .. nsel end
local r15n
for _,r in ipairs(S.xrigs) do if r.kind=="R15" then r15n=r.model.Name end end
rigChip.Text=S.rig and ("rig: " .. S.rig.Name .. (r15n and ("  +R15: " .. r15n) or "")) or (r15n and ("rig R15: " .. r15n) or L("sem rig (toque em Select)"))
end
toast=function(msg,isErr)
INFO.Text=L(msg)
INFO.TextColor3=isErr and RGB(255,120,110) or TH().accent
toastId=toastId+1
local id=toastId
task.delay(3,function() if toastId==id and gui.Parent then refreshProps() end end)
end
local CATCH
closeDD=function()
if CATCH then CATCH:Destroy(); CATCH=nil end
end
dropdown=function(anchor,items,width,maxRows)
closeDD()
local t=TH()
CATCH=new("TextButton",{Size=UDim2.fromScale(1,1),[BT]=1,Text="",ZIndex=45},W)
tap(CATCH,closeDD)
local sc=UISC.Scale
local ap=(anchor.AbsolutePosition - W.AbsolutePosition)/sc
local rows=math.min(#items,maxRows or 8)
local h=rows*24+8
width=width or 160
local x=math.clamp(ap.X,4,WIN_W - width - 4)
local y=math.clamp(ap.Y+anchor.AbsoluteSize.Y/sc+2,4,WIN_H - h - 4)
local DD=new("Frame",{Position=UO(x,y),Size=UO(width,h),[BC]=t.bg2,Active=true,ZIndex=46},CATCH)
round(DD,6)
new("UIStroke",{Color=t.accent,Thickness=1.5},DD)
local list=new("ScrollingFrame",{
Position=UO(4,4),Size=UN(1,-8,1,-8),[BT]=1,
ScrollBarThickness=3,CanvasSize=UN(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=47,
},DD)
new("UIListLayout",{Padding=UDim.new(0,2)},list)
for _,it in ipairs(items) do
local b=new("TextButton",{
Size=UN(1,-4,0,22),Text="  " .. L(it.label),TextXAlignment=XL,
[BC]=t.bg3,TextColor3=it.danger and RGB(255,120,120) or t.text,
Font=FT.GothamMedium,TextSize=11,ZIndex=48,
},list)
round(b,4)
tap(b,function() closeDD(); it.fn() end)
end
end
do
local UNIT={Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)}
local ORANGE,ORANGE_HI=RGB(255,150,30),RGB(255,215,130)
local RING_COL={RGB(84,152,255),RGB(92,222,112),RGB(238,72,72)}
local RING_HI={RGB(160,200,255),RGB(175,255,185),RGB(255,150,150)}
local HS,SEGR=6,36
local GuiService=game:GetService("GuiService")
local GF,gDrag=nil,nil
local tipScreen,segG,segFront,segE={},{{},{},{}},{{},{},{}},{{},{},{}}
local gzShown,gzMode=false,nil
local C2=V2(0,0)
local function wrapAngle(a)
while a>math.pi do a=a - 2*math.pi end
while a<-math.pi do a=a+2*math.pi end
return a
end
local function snapTo(v,step)
if step<=0 then return v end
return math.floor(v/step+0.5)*step
end
local function axisParam(ray,O,a)
local d=ray.Direction
local w0=ray.Origin - O
local b=d:Dot(a)
local denom=1 - b*b
if denom<1e-4 then return nil end
return (a:Dot(w0) - b*d:Dot(w0))/denom
end
local function ringBasis(a)
local ref=math.abs(a.Y)<0.9 and Vector3.new(0,1,0) or Vector3.new(1,0,0)
local u=a:Cross(ref).Unit
local v=a:Cross(u)
return u,v
end
local function planeAngle(ray,O,a,u,v)
local denom=ray.Direction:Dot(a)
if math.abs(denom)<1e-3 then return nil end
local s2=(O - ray.Origin):Dot(a)/denom
if s2<0 then return nil end
local rel=ray.Origin+ray.Direction*s2 - O
return math.atan2(rel:Dot(v),rel:Dot(u))
end
local function distSeg(p,a,b)
local ab=b - a
local l2=ab.X*ab.X+ab.Y*ab.Y
local t=0
if l2>0.0001 then t=math.clamp(((p.X - a.X)*ab.X+(p.Y - a.Y)*ab.Y)/l2,0,1) end
return (p - (a+ab*t)).Magnitude
end

-- visuais (pool): 6 setas laranja (haste + cone) e 3 aneis
local arrows,rings={},{{},{},{}}
for d=1,6 do
local shaft=new("Frame",{AnchorPoint=AP5,[BC]=ORANGE,Visible=false,ZIndex=3},GZ)
local heads={}
for k=1,HS do heads[k]=new("Frame",{AnchorPoint=AP5,[BC]=ORANGE,Visible=false,ZIndex=4},GZ) end
arrows[d]={shaft=shaft,heads=heads}
end
for i=1,3 do
for k=1,SEGR do
rings[i][k]=new("Frame",{AnchorPoint=AP5,[BC]=RING_COL[i],Visible=false,ZIndex=2},GZ)
end
end
local dot=new("Frame",{AnchorPoint=AP5,Size=UO(10,10),[BC]=RGB(255,255,255),Visible=false,ZIndex=7},GZ)
round(dot,5)
new("UIStroke",{Color=RGB(20,20,20),Thickness=1.5},dot)

local function hideArrow(d)
local ar=arrows[d]
ar.shaft.Visible=false
for k=1,HS do ar.heads[k].Visible=false end
tipScreen[d]=nil
end
local function hideAll()
for d=1,6 do hideArrow(d) end
for i=1,3 do
for k=1,SEGR do rings[i][k].Visible=false; segG[i][k]=nil; segFront[i][k]=false end
end
dot.Visible=false
end
local function hideGizmo()
if gzShown then gzShown=false; gzMode=nil; hideAll() end
end

-- arrasto
local function endDrag()
if gDrag then
gDrag=nil
local cam=workspace.CurrentCamera
if S.camType then pcall(function() cam.CameraType=S.camType end); S.camType=nil end
end
end
function X.torsoOf(id)
if S.motors[id] then return "Torso",S.motors.Torso,S.c0 and S.c0.Torso end
local mt=S.xmeta[id]
local r=mt and mt.rig
if not (r and r.ids and r.motors) then return nil end
local tid=r.ids.Torso
return tid,r.motors.Torso,tid and S.xinit[tid] and S.xinit[tid].c0
end
function X.limbJ(id,f)
local m,c0L=X.limbInfo(id)
if not m then return nil end
local tid,tm,c0T=X.torsoOf(id)
if not (tid and tm and c0T and tm.Part0) then return nil end
local W=tm.Part0.CFrame*c0T*evalPart(tid,f)*tm.C1:Inverse()
return W*c0L,X.ikInfo(id)
end
function X.tipWorld(id,f)
local J,ik=X.limbJ(id,f)
if not J then return nil end
return J*(evalPart(id,f)*(ik.C1i*ik.q))
end
function X.pinSolve(id,f,tgt)
tgt=tgt or S.pins[id]
if not tgt then return false end
local J,ik=X.limbJ(id,f)
if not J then return false end
local key=getKey(id,f) or ensureKey(id,f)
if locked(key) then return false end
local d0=ik.C1i*ik.q
local T=keyCF(key)
local p=T.Position
local Rc=T - p
local aim=J:Inverse()*tgt - p
local cur=Rc*d0
if aim.Magnitude<1e-4 or cur.Magnitude<1e-4 then return false end
local Rn=X.arc(cur.Unit,aim.Unit)*Rc
local rx,ry,rz=Rn:ToEulerAnglesXYZ()
key.rx,key.ry,key.rz=r3(math.deg(rx)),r3(math.deg(ry)),r3(math.deg(rz))
return true
end
function X.clamp6(sid,f)
local list={}
for pid,tgt in pairs(S.pins) do
if X.torsoOf(pid)==sid then
local J,ik=X.limbJ(pid,f)
if J then list[#list+1]={J=J.Position,T=tgt,L=(ik.C1i*ik.q).Magnitude} end
end
end
if #list==0 then return end
local TIN,TOUT=0.45,0.12
local tid,tm,c0T=X.torsoOf(sid)
local back=tm.Part0.CFrame.LookVector*-1
local D=Vector3.new(0,0,0)
for _=1,40 do
for _,q in ipairs(list) do
local s2=q.J+D
local v=s2 - q.T
local d=v.Magnitude
if d>q.L+TOUT then
D=D+(q.T+v.Unit*(q.L+TOUT)) - s2
elseif d<q.L - TIN then
local m0=q.L - TIN
local R=math.sqrt(math.max(m0*m0 - v.Y*v.Y,0))
local m=math.sqrt(v.X*v.X+v.Z*v.Z)
local ux,uz
if m<1e-4 then
local bm=math.sqrt(back.X*back.X+back.Z*back.Z)
if bm<1e-4 then ux,uz=0,1 else ux,uz=back.X/bm,back.Z/bm end
else ux,uz=v.X/m,v.Z/m end
D=D+Vector3.new(ux*R - v.X,0,uz*R - v.Z)
end
end
end
if D.Magnitude<1e-5 then return end
local key=ensureKey(sid,f)
if locked(key) then return end
local Pj=tm.Part0.CFrame*c0T
local dk=(Pj - Pj.Position):VectorToObjectSpace(D)
key.px,key.py,key.pz=r3(key.px+dk.X),r3(key.py+dk.Y),r3(key.pz+dk.Z)
end
function X.togglePin(id)
if needRig() then return end
if S.pins[id] then
S.pins[id]=nil; toast("Ponta solta")
else
local w=X.tipWorld(id,curF())
if not w then toast("Esse item não tem ponta para travar",true); return end
S.pins[id]=w; S.ik=true; if S.refreshIK then S.refreshIK() end; toast("Ponta travada no lugar. Mexa ou gire o torso: o membro se inclina")
end
rebuildTL()
end


local function prevKeyOf(part,k)
local pv
for _,o in ipairs(S.tracks[part]) do
if o.f<k.f and (not pv or o.f>pv.f) then pv=o end
end
return pv
end
function X.cfgApply(group,k,nf,ease,dir)
local delta=nf - k.f
if delta~=0 then
local set={}
for _,it in ipairs(group) do set[it.k]=true end
for _,it in ipairs(group) do
if locked(it.k) then toast("KF 0 é a posição inicial (travado): desmarque ele",true); return false end
local tf=it.k.f+delta
if tf<0 or tf>2000 then toast("Fora do limite de frames",true); return false end
for _,o in ipairs(S.tracks[it.p]) do
if o.f==tf and not set[o] then toast("Já existe um keyframe no frame " .. tf,true); return false end
end
end
end
pushUndo()
local prevs={}
for _,it in ipairs(group) do prevs[it]=prevKeyOf(it.p,it.k) end
local parts,maxF={},0
for _,it in ipairs(group) do
if delta~=0 then it.k.f=it.k.f+delta end
parts[it.p]=true; maxF=math.max(maxF,it.k.f)
end
for _,it in ipairs(group) do
local pv=prevs[it]
if pv then pv.e=ease; pv.d=dir end
end
for pp in pairs(parts) do sortT(S.tracks[pp]) end
if maxF>S.len then S.len=maxF end
S.dirty=true
rebuildTL(); applyPose(S.cur); refreshProps()
toast(#group .. " keyframe(s) atualizado(s)" .. (delta~=0 and (" (movidos " .. delta .. " frame(s))") or ""))
return true
end
function X.openCfgKF(part,k)
closeDD()
local t=TH()
local L0=selList()
local group={}
if S.selSet[k] and #L0>1 then
for _,it in ipairs(L0) do group[#group+1]=it end
else
selectKey(part,k); rebuildTL()
group={{p=part,k=k}}
end
local pv0=prevKeyOf(part,k)
local ease,dir=(pv0 and pv0.e) or "Linear",(pv0 and pv0.d) or "In"
local P0=new("TextButton",{Size=UN(1,0,1,0),[BT]=1,Text="",ZIndex=45},W)
CATCH=P0
tap(P0,closeDD)
local P=new("Frame",{Position=UO(WIN_W/2 - 160,26),Size=UO(320,180),[BC]=t.bg2,Active=true,ZIndex=46},P0)
round(P,6)
new("UIStroke",{Color=t.accent,Thickness=1.5},P)
local function lb(text,x,y,w,sz,col,bold)
return new("TextLabel",{Position=UO(x,y),Size=UO(w,18),[BT]=1,Text=L(text),Font=bold and FT.GothamBold or FT.Gotham,TextSize=sz or 10,TextColor3=col or t.text,TextXAlignment=XL,ZIndex=47},P)
end
lb("Config KF  -  " .. (#group>1 and (#group .. " keyframes (movem juntos)") or "1 keyframe"),10,6,300,11,t.text,true)
local function box(text,x,y,w)
local b=new("TextBox",{Position=UO(x,y),Size=UO(w,22),Text=text,Font=FT.Gotham,TextSize=11,ClearTextOnFocus=false,TextColor3=t.text,[BC]=t.bg3,ZIndex=47},P)
round(b,5)
return b
end
local prevF=pv0 and pv0.f or 0
lb("Frame do keyframe",10,30,140,10,t.sub)
local fb=box(tostring(k.f),10,46,64)
lb("Frames desde o anterior",160,30,150,10,t.sub)
local db=box(tostring(k.f - prevF),160,46,70)
local function setF(nf)
nf=math.max(0,math.floor((tonumber(nf) or k.f)+0.5))
fb.Text=tostring(nf); db.Text=tostring(nf - prevF)
end
fb.FocusLost:Connect(function() setF(fb.Text) end)
db.FocusLost:Connect(function() setF(prevF+(tonumber(db.Text) or 0)) end)
lb(pv0 and "Easing ao CHEGAR neste keyframe (toque p/ trocar)" or "Primeiro keyframe: nada chega nele",10,74,300,10,t.sub)
local eb=new("TextButton",{Position=UO(10,92),Size=UO(140,24),Text=ease,Font=FT.GothamBold,TextSize=11,TextColor3=t.text,[BC]=t.bg3,ZIndex=47},P)
round(eb,5)
tap(eb,function()
ease=EASES[(table.find(EASES,ease) or 0)%#EASES+1]; eb.Text=ease
end)
local dbtn=new("TextButton",{Position=UO(160,92),Size=UO(100,24),Text=dir,Font=FT.GothamBold,TextSize=11,TextColor3=t.text,[BC]=t.bg3,ZIndex=47},P)
round(dbtn,5)
tap(dbtn,function()
dir=DIRS[(table.find(DIRS,dir) or 0)%#DIRS+1]; dbtn.Text=dir
end)
local ok=new("TextButton",{Position=UO(10,134),Size=UO(142,34),Text="Aplicar",Font=FT.GothamBold,TextSize=12,TextColor3=t.ttext,[BC]=t.accent,ZIndex=47},P)
round(ok,5)
tap(ok,function()
if X.cfgApply(group,k,math.floor((tonumber(fb.Text) or k.f)+0.5),ease,dir) then closeDD(); setFrame(k.f) end
end)
local no=new("TextButton",{Position=UO(162,134),Size=UO(142,34),Text="Fechar",Font=FT.GothamBold,TextSize=12,TextColor3=t.text,[BC]=t.bg3,ZIndex=47},P)
round(no,5)
tap(no,closeDD)
end

-- ===== R15: rig com articulações, IK de dois ossos =====
X.R15CH={
{"Right Arm","RightShoulder","RightElbow","RightWrist",-1},
{"Left Arm","LeftShoulder","LeftElbow","LeftWrist",-1},
{"Right Leg","RightHip","RightKnee","RightAnkle",1},
{"Left Leg","LeftHip","LeftKnee","LeftAnkle",1},
}
function X.isR15(model)
local hum=model:FindFirstChildOfClass("Humanoid")
if not (hum and model:FindFirstChild("HumanoidRootPart")) then return nil end
local isr=false
pcall(function() isr=hum.RigType==Enum.HumanoidRigType.R15 end)
if not isr then return nil end
local list={}
for _,d in ipairs(model:GetDescendants()) do
if d:IsA("Motor6D") and d.Part0 and d.Part1 and d.Part0.Parent==model and d.Part1.Parent==model then list[#list+1]=d end
end
if #list<5 then return nil end
return list
end
function X.addRig15(model,list)
if model==S.rig then return false end
local r={model=model,motors={},ids={},kind="R15",manual=false,att={},byP1={},order={}}
local an=model:FindFirstChild("Animate")
r.animWas=an and an.Disabled
if an then an.Disabled=true end
r.hrp=model:FindFirstChild("HumanoidRootPart")
if r.hrp then r.anchWas=r.hrp.Anchored; pcall(function() r.hrp.Anchored=true end) end
local byP0={}
for _,m in ipairs(list) do
byP0[m.Part0]=byP0[m.Part0] or {}
table.insert(byP0[m.Part0],m)
end
local q,qi={r.hrp},1
while qi<=#q do
local cur=q[qi]; qi=qi+1
for _,m in ipairs(byP0[cur] or {}) do
local nm=m.Name
if r.motors[nm] then nm=nm .. "_" .. m.Part1.Name end
S.xn=S.xn+1
local id="x" .. S.xn
S.xmeta[id]={path=X.pathOf(m.Part1),kind="Motor",inst=m.Part1,tf=true,ch={},motor=m,part=nm,rig=r,r15=true}
S.xinit[id]={ch={},c0=m.C0}
S.tracks[id]={}
S.xids[#S.xids+1]=id
S.xbyInst[m.Part1]=id
r.motors[nm]=m; r.ids[nm]=id; r.byP1[m.Part1]=nm; r.order[#r.order+1]=nm
if cur==r.hrp and not r.rootName then r.rootName=nm end
pcall(function() m.Transform=CFrame.new() end)
q[#q+1]=m.Part1
end
end
if not r.rootName then return false end
S.xrigs[#S.xrigs+1]=r
X.rebuildIds()
return true
end
function X.frame15(r,part,f,memo)
if part==r.hrp then return part.CFrame end
if memo[part] then return memo[part] end
local nm=r.byP1[part]
local m=nm and r.motors[nm]
local out
if m and m.Part0 then
local id=r.ids[nm]
out=X.frame15(r,m.Part0,f,memo)*S.xinit[id].c0*evalPart(id,f)*m.C1:Inverse()
else
out=part.CFrame
end
memo[part]=out
return out
end
function X.joint15(r,nm,f)
local m=r.motors[nm]
return X.frame15(r,m.Part0,f,{})*S.xinit[r.ids[nm]].c0
end
function X.pinByEnd(id)
if not (id and S.pins15 and next(S.pins15)) then return nil end
for _,pn in pairs(S.pins15) do
if pn.ids[3]==id then return pn end
end
end
function X.capture15(pn,f)
local r=pn.r
local J=X.joint15(r,pn.def[4],f)
pn.tgt=J.Position
local F=X.frame15(r,r.motors[pn.def[4]].Part1,f,{})
pn.rot=F - F.Position
end
function X.toggle15(r,def)
local iu=r.ids[def[2]]
if not (iu and r.ids[def[3]] and r.ids[def[4]]) then toast("Esse rig não tem a cadeia " .. def[1],true); return false end
if S.pins15[iu] then
S.pins15[iu]=nil; toast("Ponta solta")
else
local pn={r=r,def=def,ids={iu,r.ids[def[3]],r.ids[def[4]]}}
X.capture15(pn,curF())
S.pins15[iu]=pn
S.ik=true; if S.refreshIK then S.refreshIK() end
toast("Ponta travada. Mexa o torso: o membro dobra e a ponta fica no lugar")
end
return true
end
local function rotApply(r,nm,key,Rw,f)
local Pj=X.joint15(r,nm,f)
local Pr=Pj - Pj.Position
local T=keyCF(key)
local Tn=Pr:Inverse()*Rw*Pr*(T - T.Position)
local rx,ry,rz=Tn:ToEulerAnglesXYZ()
key.rx,key.ry,key.rz=r3(math.deg(rx)),r3(math.deg(ry)),r3(math.deg(rz))
end
function X.solve15(r,def,f,pn)
local nu,nl,ne=def[2],def[3],def[4]
local iu,il,ie=r.ids[nu],r.ids[nl],r.ids[ne]
if not (iu and il and ie and pn and pn.tgt) then return false end
local ku,kl,ke=ensureKey(iu,f),ensureKey(il,f),ensureKey(ie,f)
if locked(ku) or locked(kl) or locked(ke) then return false end
local Sp=X.joint15(r,nu,f).Position
local E=X.joint15(r,nl,f).Position
local W=X.joint15(r,ne,f).Position
local l1,l2=(E - Sp).Magnitude,(W - E).Magnitude
local v=pn.tgt - Sp
local d=v.Magnitude
if d<1e-4 or l1<1e-4 or l2<1e-4 then return false end
local dc=math.clamp(d,math.abs(l1 - l2)+1e-3,l1+l2 - 1e-3)
local u=v/d
local a=(l1*l1 - l2*l2+dc*dc)/(2*dc)
local h=math.sqrt(math.max(l1*l1 - a*a,0))
local ev=E - Sp
local perp=ev - u*ev:Dot(u)
if perp.Magnitude<2e-3 then
local look=r.hrp.CFrame.LookVector*def[5]
perp=look - u*look:Dot(u)
if perp.Magnitude<1e-3 then perp=Vector3.new(0,1,0) - u*u.Y end
end
local E2=Sp+u*a+perp.Unit*h
local W2=Sp+u*dc
rotApply(r,nu,ku,X.arc((E - Sp).Unit,(E2 - Sp).Unit),f)
local En=X.joint15(r,nl,f).Position
local Wn=X.joint15(r,ne,f).Position
if (Wn - En).Magnitude>1e-4 and (W2 - En).Magnitude>1e-4 then
rotApply(r,nl,kl,X.arc((Wn - En).Unit,(W2 - En).Unit),f)
end
if pn.rot then
local me=r.motors[ne]
local Pw=X.joint15(r,ne,f)
local c1=me.C1
local Tn=(Pw - Pw.Position):Inverse()*pn.rot*(c1 - c1.Position)
local rx,ry,rz=Tn:ToEulerAnglesXYZ()
ke.rx,ke.ry,ke.rz=r3(math.deg(rx)),r3(math.deg(ry)),r3(math.deg(rz))
end
return true
end
function X.clamp15(r,f)
local list={}
for _,pn in pairs(S.pins15) do
if pn.r==r then
local Sp=X.joint15(r,pn.def[2],f).Position
local E=X.joint15(r,pn.def[3],f).Position
local W=X.joint15(r,pn.def[4],f).Position
list[#list+1]={Sp=Sp,P=pn.tgt,mx=(E - Sp).Magnitude+(W - E).Magnitude - 0.02}
end
end
if #list==0 then return end
local D=Vector3.new(0,0,0)
for _=1,16 do
for _,q in ipairs(list) do
local s2=q.Sp+D
local dv=s2 - q.P
if dv.Magnitude>q.mx then D=D+(q.P+dv.Unit*q.mx) - s2 end
end
end
if D.Magnitude<1e-5 then return end
local rid=r.ids[r.rootName]
local key=ensureKey(rid,f)
if locked(key) then return end
local Pj=r.hrp.CFrame*S.xinit[rid].c0
local dk=(Pj - Pj.Position):VectorToObjectSpace(D)
key.px,key.py,key.pz=r3(key.px+dk.X),r3(key.py+dk.Y),r3(key.pz+dk.Z)
end
function X.after15(r,sid,f,d)
local chain
for _,pn in pairs(S.pins15) do
if pn.r==r and (pn.ids[1]==sid or pn.ids[2]==sid or pn.ids[3]==sid) then chain=pn end
end
if chain then
if not d.pin15 then X.capture15(chain,f) end
return
end
if S.ik then
X.clamp15(r,f)
for _,pn in pairs(S.pins15) do
if pn.r==r then X.solve15(r,pn.def,f,pn) end
end
end
end
function X.exportR15(r,name)
local frames,any={},false
for _,nm in ipairs(r.order) do
for _,k in ipairs(S.tracks[r.ids[nm]]) do frames[k.f]=true; any=true end
end
if not any then return nil end
local list={}
if S.expBake then
local dur=playEnd()/S.fps
local n=math.ceil(dur*60 - 1e-9)
for i=0,n - 1 do list[#list+1]=(i/60)*S.fps end
list[#list+1]=dur*S.fps
else
for f in pairs(frames) do list[#list+1]=f end
table.sort(list)
end
local ks=Instance.new("KeyframeSequence")
ks.Name=name .. "_R15"; ks.Loop=S.loop
pcall(function() ks.Priority=Enum.AnimationPriority[S.prio] end)
for _,f in ipairs(list) do
local kf=Instance.new("Keyframe")
kf.Time=f/S.fps
local root=Instance.new("Pose"); root.Name="HumanoidRootPart"; root.Weight=0; root.Parent=kf
local poses={[r.hrp]=root}
for _,nm in ipairs(r.order) do
local m=r.motors[nm]
local p=Instance.new("Pose")
p.Name=m.Part1.Name; p.Weight=1
p.CFrame=evalPart(r.ids[nm],f)
pcall(function() p.EasingStyle=Enum.PoseEasingStyle.Linear; p.EasingDirection=Enum.PoseEasingDirection.Out end)
p.Parent=poses[m.Part0] or root
poses[m.Part1]=p
end
kf.Parent=ks
end
ks.Parent=workspace
return ks
end
local function startDrag(kind,ai,inp,g0)
if not (GF and (S.rig or #S.xrigs>0)) then return false end
if S.playing then setPlaying(false) end
local cam=workspace.CurrentCamera
local ray0=cam:ScreenPointToRay(g0.X,g0.Y)
local d={kind=kind,ai=ai,input=inp,space=S.space,J=GF.J,O=GF.O,a=GF.axes[ai],
p0=V2(inp.Position.X,inp.Position.Y),g0=g0,camCF=cam.CFrame}
if kind=="move" then
d.t0=axisParam(ray0,d.O,d.a)
if not d.t0 then return false end
d.step=S.stepMove
else
d.u,d.v=ringBasis(d.a)
d.last=planeAngle(ray0,d.O,d.a,d.u,d.v)
if not d.last then return false end
d.acc=0; d.step=math.rad(S.stepRot)
end
local f=curF()
local key=getKey(S.sel,f)
if key and locked(key) then toast("KF 0 é a posição inicial (travado). Destrave em Config",true); return false end
if not key then
if not S.autokey then toast("Sem keyframe neste frame: use +KF",true); return false end
pushUndo(); key=ensureKey(S.sel,f); selectKey(S.sel,key); rebuildTL()
else
pushUndo()
if S.selKey~=key then selectKey(S.sel,key); rebuildTL() end
end
local T=keyCF(key)
d.key=key; d.pT=T.Position; d.RT=T - T.Position
if GF.ik then d.ik=GF.ik; d.P0=GF.O end
if S.ik and kind=="move" then local pn=X.pinByEnd(S.sel); if pn then d.pin15=pn; d.P0=pn.tgt end end
if S.sel=="Torso" and not S.follow and S.c0 and S.motors.Torso then
d.fol={}; d.Tr0=T
for _,p in ipairs(PARTS) do
if p~="Torso" then
local lk=ensureKey(p,f)
d.fol[p]={key=lk,T0=keyCF(lk)}
end
end
rebuildTL()
end
S.camType=cam.CameraType
S.lastDragT=os.clock()
cam.CameraType=Enum.CameraType.Scriptable
cam.CFrame=d.camCF
gDrag=d
return true
end
local function dragUpdate(i)
local d=gDrag
local cam=workspace.CurrentCamera
local g=d.g0+(V2(i.Position.X,i.Position.Y) - d.p0)
local ray=cam:ScreenPointToRay(g.X,g.Y)
local key=d.key
if d.kind=="move" then
local t=axisParam(ray,d.O,d.a)
if not t then return end
local dist=snapTo(t - d.t0,d.step)
if d.pin15 then
d.pin15.tgt=d.P0+UNIT[d.ai]*dist
X.solve15(d.pin15.r,d.pin15.def,curF(),d.pin15)
elseif d.ik then
local target=d.P0+UNIT[d.ai]*dist
if S.pins[S.sel] then S.pins[S.sel]=target end
X.pinSolve(S.sel,curF(),target)
else
local np
if d.space=="local" then np=d.pT+d.RT:VectorToWorldSpace(UNIT[d.ai]*dist)
else np=d.pT+d.J:VectorToObjectSpace(UNIT[d.ai]*dist) end
key.px,key.py,key.pz=r3(np.X),r3(np.Y),r3(np.Z)
end
else
local ang=planeAngle(ray,d.O,d.a,d.u,d.v)
if not ang then return end
d.acc=d.acc+wrapAngle(ang - d.last)
d.last=ang
local da=snapTo(d.acc,d.step)
local nr
if d.space=="local" then nr=d.RT*CFrame.fromAxisAngle(UNIT[d.ai],da)
else nr=CFrame.fromAxisAngle(d.J:VectorToObjectSpace(UNIT[d.ai]),da)*d.RT end
local rx,ry,rz=nr:ToEulerAnglesXYZ()
key.rx,key.ry,key.rz=r3(math.deg(rx)),r3(math.deg(ry)),r3(math.deg(rz))
end
if d.fol and S.c0 and S.motors.Torso then
local c1r=S.motors.Torso.C1
local mid=c1r*keyCF(key):Inverse()*d.Tr0*c1r:Inverse()
for p,fo in pairs(d.fol) do
local c0l=S.c0[p]
if c0l then
local nT=c0l:Inverse()*mid*c0l*fo.T0
local rx2,ry2,rz2=nT:ToEulerAnglesXYZ()
local pp=nT.Position
local lk=fo.key
lk.px,lk.py,lk.pz=r3(pp.X),r3(pp.Y),r3(pp.Z)
lk.rx,lk.ry,lk.rz=r3(math.deg(rx2)),r3(math.deg(ry2)),r3(math.deg(rz2))
end
end
end
do
local sid=S.sel
local mt=S.xmeta[sid]
if mt and mt.rig and mt.rig.kind=="R15" then
X.after15(mt.rig,sid,curF(),d)
elseif sid=="Torso" or (mt and mt.part=="Torso") then
if S.ik then
local f=curF()
X.clamp6(sid,f)
for pid in pairs(S.pins) do
if X.torsoOf(pid)==sid then X.pinSolve(pid,f) end
end
end
elseif S.pins[sid] and not d.ik then
S.pins[sid]=X.tipWorld(sid,curF()) or S.pins[sid]
end
end
S.dirty=true
applyPose(S.cur); refreshProps()
end
local function isDragInput(i)
return gDrag and (i==gDrag.input or (i.UserInputType==Enum.UserInputType.MouseMovement and gDrag.input.UserInputType==Enum.UserInputType.MouseButton1))
end
moveCB[#moveCB+1]=function(i) if isDragInput(i) then dragUpdate(i) end end
moveCB[#moveCB+1]=function(i)
if rowDrag and not gDrag then
local n=math.floor((rowDrag.y0 - i.Position.Y)/(ROW*0.8))
local nr=math.clamp(rowDrag.r0+n,1,math.max(1,rowDrag.n - 5))
if nr~=S.xrow0 then S.xrow0=nr; rowDrag.moved=true; rebuildTL() end
end
end
endCB[#endCB+1]=function() rowDrag=nil end
endCB[#endCB+1]=function(i) if gDrag and (i==gDrag.input or (i and i.UserInputType==Enum.UserInputType.MouseButton1)) then endDrag() end end

-- congela a camera enquanto o gizmo esta sendo arrastado (a tela nao acompanha o dedo)
pcall(function()
RunService:BindToRenderStep("HaxCamPin",Enum.RenderPriority.Last.Value,function()
if gDrag then workspace.CurrentCamera.CFrame=gDrag.camCF end
end)
end)

-- toque perto do gizmo (mesmo sem acertar a linha) comeca o arrasto
conns[#conns+1]=UIS.InputBegan:Connect(function(inp,gp)
if gp or gDrag or not GF or not isPress(inp) then return end
local inset=GuiService:GetGuiInset()
local raw=V2(inp.Position.X,inp.Position.Y)
local bestScore,kind,ai,g0=1e9,nil,nil,nil
for _,p in ipairs({raw - (S.posOff or V2(0,0))}) do
if S.gmode=="move" then
for d=1,6 do
local tp=tipScreen[d]
if tp and (p - C2).Magnitude>=12 then
local score=distSeg(p,C2+(tp - C2)*0.35,tp)
if score<26 and score<bestScore then bestScore=score; kind="move"; ai=math.floor((d+1)/2); g0=tp end
end
end
else
for i=1,3 do
for k=1,SEGR do
local e=segE[i][k]
if e and segFront[i][k] then
local score=distSeg(p,e[1],e[2])
if score<16 and score<bestScore then bestScore=score; kind="rot"; ai=i; g0=segG[i][k] end
end
end
end
end
end
if kind then startDrag(kind,ai,inp,g0) end
end)

function updateGizmo()
GF=nil
local cam=workspace.CurrentCamera
local part=S.sel
local J=((S.rig or #S.xrigs>0) and S.gmode and not mini and not S.playing) and X.trackJ(part) or nil
if not (J and cam) then hideGizmo(); return end
local fr=J*evalPart(part,S.cur)
local O=fr.Position
local ik=S.ik and S.gmode=="move" and X.ikInfo(part)
if ik then O=(fr*ik.C1i)*ik.q end
local ik15=S.ik and S.gmode=="move" and X.pinByEnd(part)
local cv=cam:WorldToScreenPoint(O)
if cv.Z<=0 then hideGizmo(); return end
if gzMode~=S.gmode then hideAll(); gzMode=S.gmode end
gzShown=true
local c2=V2(cv.X,cv.Y)
C2=c2
local dist=(cam.CFrame.Position - O).Magnitude
local pxPerStud=cam.ViewportSize.Y/(2*dist*math.tan(math.rad(cam.FieldOfView)/2))
local len=84/pxPerStud
local rad=74/pxPerStud
local axes={}
for i=1,3 do axes[i]=(S.space=="local" and not ik and not ik15) and fr:VectorToWorldSpace(UNIT[i]) or UNIT[i] end
GF={J=J,O=O,axes=axes,ik=ik}
local look=cam.CFrame.LookVector
dot.Position=UO(c2.X,c2.Y); dot.Visible=true

if S.gmode=="move" then
for d=1,6 do
local ai=math.floor((d+1)/2)
local dirW=axes[ai]*((d % 2==1) and 1 or -1)
local tv=cam:WorldToScreenPoint(O+dirW*len)
local ar=arrows[d]
local ok=false
if tv.Z>0 then
local t2=V2(tv.X,tv.Y)
local dv=t2 - c2
local L=dv.Magnitude
if L>14 then
ok=true
local un=dv/L
local ang=math.deg(math.atan2(dv.Y,dv.X))
local headL=math.min(18,L*0.5)
local headW=15*headL/18
local shaftL=L - headL*0.8
local mid=c2+un*(shaftL/2)
local hi=gDrag and gDrag.kind=="move" and gDrag.ai==ai
local col=hi and ORANGE_HI or ORANGE
local tr=(dirW:Dot(look)<0.25) and 0 or 0.45
ar.shaft.Position=UO(mid.X,mid.Y); ar.shaft.Size=UO(shaftL,hi and 5 or 4); ar.shaft.Rotation=ang
ar.shaft.BackgroundColor3=col; ar.shaft.BackgroundTransparency=tr; ar.shaft.Visible=true
local base=t2 - un*headL
for k=1,HS do
local f2=(k - 0.5)/HS
local p=base+un*(headL*f2)
local h=ar.heads[k]
h.Position=UO(p.X,p.Y); h.Size=UO(headL/HS+1,math.max(headW*(1 - f2),1)); h.Rotation=ang
h.BackgroundColor3=col; h.BackgroundTransparency=tr; h.Visible=true
end
tipScreen[d]=t2
end
end
if not ok then hideArrow(d) end
end
else
for i=1,3 do
local u,v=ringBasis(axes[i])
local pts,oks,pws={},{},{}
for k=0,SEGR do
local th=2*math.pi*k/SEGR
local pw=O+(u*math.cos(th)+v*math.sin(th))*rad
local sv=cam:WorldToScreenPoint(pw)
pts[k]=V2(sv.X,sv.Y); oks[k]=sv.Z>0; pws[k]=pw
end
local hi=gDrag and gDrag.kind=="rot" and gDrag.ai==i
for k=1,SEGR do
local b=rings[i][k]
if oks[k - 1] and oks[k] then
local dv=pts[k] - pts[k - 1]
local mid=(pts[k]+pts[k - 1])/2
local front=((pws[k]+pws[k - 1])/2 - O):Dot(look)<0
segG[i][k]=mid; segFront[i][k]=front; segE[i][k]={pts[k - 1],pts[k]}
b.Position=UO(mid.X,mid.Y)
b.Size=UO(dv.Magnitude+1.5,front and (hi and 6 or 5) or 2)
b.Rotation=math.deg(math.atan2(dv.Y,dv.X))
b.BackgroundColor3=hi and RING_HI[i] or RING_COL[i]
b.BackgroundTransparency=front and 0.02 or 0.7
b.ZIndex=front and 5 or 2
b.Visible=true
else
segG[i][k]=nil; segFront[i][k]=false
b.Visible=false
end
end
end
end
end
end

local PANEL_SIZE=UN(1,0,1,-TITLE_H)
SP=new("Frame",{Position=UO(0,TITLE_H),Size=PANEL_SIZE,Visible=false,ZIndex=20,Active=true},W)
paint(SP,"bg"); S.reg(SP)
FP=new("Frame",{Position=UO(0,TITLE_H),Size=PANEL_SIZE,Visible=false,ZIndex=20,Active=true},W)
paint(FP,"bg"); S.reg(FP)
showPanel=function(p)
closeDD()
local was=p.Visible
for _,pp in ipairs(S.panels) do pp.Visible=false end
p.Visible=not was
end
do
lbl(SP,"CONFIGURAÇÕES",8,4,140,20,12,true)
local langB={}
for i,c in ipairs({{"pt-BR","PT-BR"},{"pt-PT","PT-PT"},{"es","ES"},{"en","EN"}}) do
local b,e=btn(SP,c[2],150+(i - 1)*44,4,40,20,function()
S.lang=c[1]; saveSettings(); S.relang()
for _,lb in ipairs(langB) do setOn(lb[1],lb[2],lb[3]==S.lang) end
rebuildTL(); refreshProps(); rebuildFilesList()
if X.refreshBtns then X.refreshBtns() end
end,nil,FT.GothamBold,9)
langB[i]={b,e,c[1]}
setOn(b,e,c[1]==S.lang)
end
local closeSP=btn(SP,"Fechar",0,4,60,20,function() SP.Visible=false end,"accent")
closeSP.Position=UN(1,-68,0,4)
lbl(SP,"Transparência",8,28,100,16,11,false,"sub")
slider(SP,UO(112,29),UN(1,-124,0,14),0,0.9,S.alpha,function(v)
S.alpha=v; applyStyle(); rebuildTL()
end,{
onStart=function() S.ghost=true; applyStyle() end,
onEnd=function() S.ghost=false; applyStyle(); saveSettings() end,
})
lbl(SP,"Tamanho",8,48,100,16,11,false,"sub")
local scaleLbl=lbl(SP,string.format("%d%%",math.floor(S.scale*100+0.5)),152,46,50,20,11,true)
local function setScale(v)
S.scale=math.clamp(math.floor(v*10+0.5)/10,0.5,1.4)
UISC.Scale=S.scale
scaleLbl.Text=string.format("%d%%",math.floor(S.scale*100+0.5))
saveSettings()
end
btn(SP,"-",112,46,34,20,function() setScale(S.scale - 0.1) end,nil,FT.GothamBlack,14)
btn(SP,"+",206,46,34,20,function() setScale(S.scale+0.1) end,nil,FT.GothamBlack,14)
lbl(SP,"Largura",8,68,100,16,11,false,"sub")
local wLbl=lbl(SP,tostring(S.w),400,66,40,20,11,true)
slider(SP,UO(112,69),UO(280,14),440,720,S.w,function(v)
S.w=math.floor(v/10+0.5)*10
wLbl.Text=tostring(math.clamp(S.w,440,720))
applyLayout(); rebuildTL()
end,{onEnd=saveSettings})
lbl(SP,"Altura",8,88,100,16,11,false,"sub")
local hLbl=lbl(SP,tostring(S.h),400,86,40,20,11,true)
slider(SP,UO(112,89),UO(280,14),270,430,S.h,function(v)
S.h=math.floor(v/10+0.5)*10
hLbl.Text=tostring(math.clamp(S.h,270,430))
applyLayout(); rebuildTL()
end,{onEnd=saveSettings})
lbl(SP,"Tema",8,110,34,20,11,false,"sub")
btn(SP,"Paleta",40,110,56,20,function()
X.pickColor(TH().accent,function(c)
local lum=0.299*c.R+0.587*c.G+0.114*c.B
THEMES.Custom=mkTheme(c,lum>0.6 and Color3.new(0,0,0) or nil)
S.customAccent=c; S.theme="Custom"
applyStyle(); rebuildTL(); rebuildFilesList(); setHighlight(S.rig); saveSettings()
end)
end,"accent")
for i,name in ipairs(THEME_ORDER) do
local th=THEMES[name]
local b=new("TextButton",{
Text=name,Position=UO(100+(i - 1)*46,110),Size=UO(44,20),
[BC]=th.accent,TextColor3=th.ttext,Font=FT.GothamBold,TextSize=9,
},SP)
round(b,5)
tap(b,function() S.theme=name; applyStyle(); rebuildTL(); rebuildFilesList(); setHighlight(S.rig); saveSettings() end)
end
local KFC={
RGB(255,150,30),RGB(255,220,60),RGB(70,150,255),RGB(160,100,235),
RGB(235,70,70),RGB(80,220,110),RGB(240,240,240),
}
lbl(SP,"KF",8,132,34,20,11,false,"sub")
btn(SP,"Paleta",40,132,56,20,function()
X.pickColor(S.kfColor,function(c) S.kfColor=c; rebuildTL(); saveSettings() end)
end,"accent")
for i,c in ipairs(KFC) do
local b=new("TextButton",{Text="",Position=UO(100+(i - 1)*46,132),Size=UO(44,20),[BC]=c},SP)
round(b,5)
tap(b,function() S.kfColor=c; rebuildTL(); saveSettings() end)
end
lbl(SP,"KF sel.",8,154,34,20,10,false,"sub")
btn(SP,"Paleta",40,154,56,20,function()
X.pickColor(S.kfSel,function(c) S.kfSel=c; rebuildTL(); saveSettings() end)
end,"accent")
for i,c in ipairs(KFC) do
local b=new("TextButton",{Text="",Position=UO(100+(i - 1)*46,154),Size=UO(44,20),[BC]=c},SP)
round(b,5)
tap(b,function() S.kfSel=c; rebuildTL(); saveSettings() end)
end
lbl(SP,"FPS",8,178,30,20,11,false,"sub")
tbox(SP,tostring(S.fps),34,178,44,function(txt,b)
local n=tonumber(txt)
if n then S.fps=math.clamp(math.floor(n),1,120) end
b.Text=tostring(S.fps); updatePlayhead()
end)
lbl(SP,"Frames",88,178,44,20,11,false,"sub")
tbox(SP,tostring(S.len),134,178,52,function(txt,b)
local n=tonumber(txt)
if n then S.len=math.clamp(math.floor(n),10,2000) end
b.Text=tostring(S.len); S.cur=math.min(S.cur,S.len); rebuildTL()
end)
local autoB,autoE,ancB,ancE,asB,asE
autoB,autoE=btn(SP,"Auto-key",194,178,70,20,function() S.autokey=not S.autokey; setOn(autoB,autoE,S.autokey); saveSettings() end)
ancB,ancE=btn(SP,"Ancorar rig",268,178,80,20,function() S.anchor=not S.anchor; setOn(ancB,ancE,S.anchor); applyAnchor() end)
asB,asE=btn(SP,"Autosave",352,178,80,20,function() S.autosave=not S.autosave; setOn(asB,asE,S.autosave); saveSettings() end)
setOn(autoB,autoE,S.autokey); setOn(ancB,ancE,S.anchor); setOn(asB,asE,S.autosave)
btn(SP,"Limpar tudo",8,202,84,20,ACT.clearAll)
btn(SP,"Soltar rig",96,202,72,20,function() releaseRig(); refreshProps(); toast("Rig solto") end)
btn(SP,"Forçar pose",172,202,78,20,function() S.manual=not S.manual; applyPose(S.cur); toast("Forçar pose: " .. (S.manual and "ligado" or "desligado")) end)
local elB,elE
elB,elE=btn(SP,"Fim=último KF",254,202,96,20,function() S.endLast=not S.endLast; setOn(elB,elE,S.endLast); saveSettings() end)
setOn(elB,elE,S.endLast)
local lkB,lkE
lkB,lkE=btn(SP,"Travar KF 0",354,202,82,20,function() S.lock0=not S.lock0; setOn(lkB,lkE,S.lock0); saveSettings() end)
setOn(lkB,lkE,S.lock0)
lbl(SP,"Imagem de fundo (ID)",8,226,130,20,10,false,"sub")
local bgBox=tbox(SP,S.bgId,138,226,100,function() end)
btn(SP,"Aplicar",244,226,60,20,function()
S.bgId=(bgBox.Text:gsub("%D",""))
saveSettings(); S.applyBg()
toast(S.bgId=="" and "Fundo removido" or "Fundo aplicado (use o ID da IMAGEM, não do decal)")
end,"accent")
btn(SP,"Remover",308,226,60,20,function() S.bgId=""; bgBox.Text=""; saveSettings(); S.applyBg() end)
lbl(FP,"ARQUIVOS  |  conta: " .. LP.Name,8,4,300,20,12,true)
local closeFP=btn(FP,"Fechar",0,4,60,20,function() FP.Visible=false end,"accent")
closeFP.Position=UN(1,-68,0,4)
lbl(FP,"Nome",8,30,36,20,11,false,"sub")
nameBox=tbox(FP,S.name,44,30,112,function(txt,b)
txt=txt:gsub("^%s+",""):gsub("%s+$","")
if txt=="" then txt="Anim" end
S.name=txt; b.Text=txt
end)
btn(FP,"Salvar",162,30,54,20,function()
S.name=nameBox.Text~="" and nameBox.Text or "Anim"
DB.anims[S.name]=serialize(); dbSave(); rebuildFilesList()
toast("Salvo: " .. S.name .. (fs and " (arquivo)" or " (so memoria)"))
end,"accent")
btn(FP,"Exportar KFS",220,30,100,20,function() S.name=nameBox.Text~="" and nameBox.Text or S.name; X.openExport() end,"accent")
btn(FP,"Copiar JSON",324,30,108,20,function()
local json=HttpService:JSONEncode(serialize())
if typeof(setclipboard)=="function" then setclipboard(json); toast("JSON copiado")
else jsonBox.Text=json; toast("Sem clipboard: JSON na caixa abaixo") end
end)
jsonBox=new("TextBox",{
Position=UO(8,56),Size=UO(318,22),Text="",PlaceholderText="Cole aqui o JSON de uma animação",
Font=FT.Gotham,TextSize=10,ClearTextOnFocus=true,TextXAlignment=XL,
},FP)
paint(jsonBox,"bg3",0,"text"); round(jsonBox,5)
btn(FP,"Importar",330,56,102,22,function()
local ok,d=pcall(function() return HttpService:JSONDecode(jsonBox.Text) end)
if ok and type(d)=="table" and d.tracks then
deserialize(d); nameBox.Text=S.name; jsonBox.Text=""
rebuildTL(); applyPose(0); refreshProps(); toast("Animacao importada")
else
toast("JSON invalido",true)
end
end)
lbl(FP,"Salvas: " .. (fs and "arquivo" or "memória"),8,82,150,16,10,false,"sub")
local prB
prB=btn(FP,"Prioridade: " .. S.prio,162,80,130,18,function()
local order={"Idle","Movement","Action","Core"}
S.prio=order[(table.find(order,S.prio) or 3) % #order+1]
S.setT(prB,"Prioridade: " .. S.prio)
end,nil,FT.GothamBold,10)
local ebB
ebB=btn(FP,"Export: " .. (S.expBake and "Assado (= Play)" or "Só keyframes"),296,80,136,18,function()
S.expBake=not S.expBake
S.setT(ebB,"Export: " .. (S.expBake and "Assado (= Play)" or "Só keyframes"))
saveSettings()
end,nil,FT.GothamBold,10)
local LIST=new("ScrollingFrame",{
Position=UO(8,100),Size=UN(1,-16,1,-(TITLE_H+108)),ScrollBarThickness=3,
CanvasSize=UN(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=21,
},FP)
paint(LIST,"bg2"); round(LIST,5)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},LIST)
new("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,3)},LIST)
rebuildFilesList=function()
if prB then S.setT(prB,"Prioridade: " .. S.prio) end
local t=TH()
for _,c in ipairs(LIST:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
local names={}
for n in pairs(DB.anims) do names[#names+1]=n end
table.sort(names)
if #names==0 then
local e=new("Frame",{Size=UN(1,-8,0,24),[BT]=1,ZIndex=22},LIST)
new("TextLabel",{Size=UDim2.fromScale(1,1),[BT]=1,Text="Nenhuma animação salva ainda",Font=FT.Gotham,TextSize=10,TextColor3=t.sub,ZIndex=22},e)
end
for i,n in ipairs(names) do
local row=new("Frame",{Size=UN(1,-8,0,24),[BC]=t.bg3,LayoutOrder=i,ZIndex=22},LIST)
round(row,5)
new("TextLabel",{
Position=UO(8,0),Size=UN(1,-140,0,24),[BT]=1,Text=n,
Font=FT.GothamMedium,TextSize=11,TextColor3=t.text,TextXAlignment=XL,ZIndex=23,
},row)
local ob=new("TextButton",{Text="Abrir",Position=UN(1,-132,0,2),Size=UO(60,20),[BC]=t.accent,TextColor3=t.ttext,Font=FT.GothamBold,TextSize=10,ZIndex=23},row)
local db=new("TextButton",{Text="Apagar",Position=UN(1,-66,0,2),Size=UO(60,20),[BC]=RGB(160,44,44),TextColor3=Color3.new(1,1,1),Font=FT.GothamBold,TextSize=10,ZIndex=23},row)
round(ob,5); round(db,5)
tap(ob,function()
deserialize(DB.anims[n]); nameBox.Text=S.name
FP.Visible=false
rebuildTL(); applyPose(0); refreshProps(); toast("Aberta: " .. n)
end)
tap(db,function() DB.anims[n]=nil; dbSave(); rebuildFilesList(); toast("Apagada: " .. n) end)
end
end
end
do
local x=5
local function place(b,w) b.Position=UO(x,3); b.Size=UO(w,22); x=x+w+4 end
local function mk(text,w,cb,style,font,size)
local b,e=btn(TOOLBAR,text,0,0,w,22,cb,style,font,size)
place(b,w)
return b,e
end
selB,selE=mk("Select",56,function() setPicking(not picking) end,"accent")
local rigBtn
rigBtn=mk("Rig",38,function()
local list=findRigs()
local items={}
if S.rig then items[#items+1]={label="Soltar rig atual",danger=true,fn=function() releaseRig(); refreshProps(); toast("Rig solto") end} end
for _,m in ipairs(list) do
items[#items+1]={label=m.Name .. (m==LP.Character and " (você)" or ""),fn=function() loadRig(m) end}
end
if #items==0 then toast("Nenhum rig R6 encontrado",true); return end
dropdown(rigBtn,items,190,7)
end)
mk("‹",26,function() setPlaying(false); setFrame(curF() - 1) end,nil,FT.GothamBlack,16)
playBtn=mk("►",36,function() setPlaying(not S.playing) end,"accent",FT.SourceSansBold,16)
mk("■",26,function() setPlaying(false); setFrame(0) end,nil,FT.SourceSansBold,16)
mk("›",26,function() setPlaying(false); setFrame(curF()+1) end,nil,FT.GothamBlack,16)
x=x+2
mk("+KF",40,ACT.addKey,"accent")
mk("-KF",36,ACT.delKey)
x=x+2
local function applyEase(field,val)
if needSel() then return end
local L=selList()
if #L==0 then
local t=S.tracks[S.sel]
local prev
for _,kk in ipairs(t) do if kk.f<=curF() then prev=kk end end
if prev then L={{p=S.sel,k=prev}} end
end
if #L==0 then toast("Sem keyframe aqui: o easing vira o padrão dos novos keyframes"); return end
local fixed,done,note={},{},nil
for _,it in ipairs(L) do
local t=S.tracks[it.p]
local k=it.k
if t[#t]==k and #t>1 then k=t[#t - 1]; note="último keyframe: aplicado no trecho que chega nele" end
if not done[k] then done[k]=true; fixed[#fixed+1]=k end
end
if #S.tracks[L[1].p]<2 then toast("Só há 1 keyframe nesta trilha: nada para suavizar",true); return end
pushUndo()
for _,k in ipairs(fixed) do k[field]=val end
applyPose(S.cur); rebuildTL()
toast((note or "Easing aplicado") .. " (" .. #fixed .. " trecho(s))")
end
S.applyEase=applyEase
easeBtn=mk(S.ease,64,function()
local items={}
for _,e in ipairs(EASES) do
items[#items+1]={label=(e==S.ease and "› " or "") .. e,fn=function()
S.ease=e; easeBtn.Text=e; applyEase("e",e)
end}
end
dropdown(easeBtn,items,130,8)
end,nil,FT.GothamBold,10)
dirBtn=mk(S.dir,38,function()
local items={}
for _,d in ipairs(DIRS) do
items[#items+1]={label=(d==S.dir and "› " or "") .. d,fn=function()
S.dir=d; dirBtn.Text=d; applyEase("d",d)
end}
end
dropdown(dirBtn,items,90,3)
end,nil,FT.GothamBold,10)
end
do
local modeB,modeE={},{}
local spaceB
function refreshGizmoBtns()
setOn(modeB.move,modeE.move,S.gmode=="move")
setOn(modeB.rot,modeE.rot,S.gmode=="rot")
setOn(modeB.off,modeE.off,S.gmode==nil)
S.setT(spaceB,(S.space=="local") and "Eixos: Local" or "Eixos: Mundo")
end
modeB.move,modeE.move=btn(BOT,"Mover",4,2,52,20,function() S.gmode="move"; refreshGizmoBtns() end)
modeB.rot,modeE.rot=btn(BOT,"Girar",60,2,52,20,function() S.gmode="rot"; refreshGizmoBtns() end)
modeB.off,modeE.off=btn(BOT,"Off",116,2,34,20,function() S.gmode=nil; refreshGizmoBtns() end,nil,FT.GothamBold,10)
spaceB=btn(BOT,"Eixos: Local",4,26,84,20,function()
S.space=(S.space=="local") and "world" or "local"; refreshGizmoBtns()
end,nil,FT.GothamBold,10)
local loopB,loopE
loopB,loopE=btn(BOT,"Loop",92,26,58,20,function() S.loop=not S.loop; setOn(loopB,loopE,S.loop) end,nil,FT.GothamBold,10)
setOn(loopB,loopE,S.loop)
lbl(BOT,"Mover",158,2,40,20,10,true,"sub")
tbox(BOT,tostring(S.stepMove),200,2,66,function(txt,bx)
local n=tonumber(txt)
if n then S.stepMove=math.clamp(r3(n),0.001,1); saveSettings() end
bx.Text=tostring(S.stepMove)
end)
lbl(BOT,"Girar",158,26,40,20,10,true,"sub")
tbox(BOT,tostring(S.stepRot),200,26,66,function(txt,bx)
local n=tonumber(txt)
if n then S.stepRot=math.clamp(math.floor(n*100+0.5)/100,1,90); saveSettings() end
bx.Text=tostring(S.stepRot)
end)
local fB,fE
fB,fE=btn(BOT,"Follow Torso",272,2,108,20,function()
S.follow=not S.follow; setOn(fB,fE,S.follow); saveSettings()
toast("Follow Torso: " .. (S.follow and "ligado (membros acompanham)" or "desligado (membros ficam parados)"))
end,nil,FT.GothamBold,10)
setOn(fB,fE,S.follow)
local ikB,ikE
ikB,ikE=btn(BOT,"IK",384,2,52,20,function()
X.openIK()
end,nil,FT.GothamBold,11)
S.refreshIK=function() setOn(ikB,ikE,S.ik) end
setOn(ikB,ikE,S.ik)
local exB,sxB,sxE,valB
exB=btn(BOT,"Explorer +Part/VFX",272,26,164,20,function() X.openExplorer() end,nil,FT.GothamBold,10)
sxB,sxE=btn(BOT,"Second Anim",272,26,96,20,function() X.toggleMode() end,nil,FT.GothamBold,10)
valB=btn(BOT,"Valores",272,2,108,20,function() X.openValues() end,"accent",FT.GothamBold,10)
function X.refreshBtns()
local has=#S.xroots>0
sxB.Visible=has
exB.Position=has and UO(372,26) or UO(272,26)
exB.Size=has and UO(64,20) or UO(164,20)
S.setT(exB,has and "Explorer" or "Explorer +Part/VFX")
setOn(sxB,sxE,S.xmode)
fB.Visible=not S.xmode
local mt=S.xmeta[S.sel]
valB.Visible=S.xmode and mt~=nil and #mt.ch>0
end
function X.toggleMode()
if #S.xroots==0 then X.openExplorer(); return end
S.xmode=not S.xmode
S.xrow0=1; S.selKey=nil
if S.xmode then
for _,r in ipairs(X.rows()) do
if r.id then S.sel=r.id; break end
end
elseif S.xmeta[S.sel] then S.sel="Torso" end
rebuildTL(); refreshProps()
toast(S.xmode and "Second Anim: toque em + para abrir os filhos; toque no nome para animar" or "Voltou para o rig")
end
end
;(function()
local REQ=request or http_request or (syn and syn.request) or (http and http.request)
local ID_CH="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local B={}
local stat
local function say(m,err)
if stat then stat.Text=L(m); stat.TextColor3=err and RGB(255,120,110) or TH().accent end
end
local function trim(x) return (tostring(x or ""):gsub("^%s+",""):gsub("%s+$","")) end
local function base()
local u=trim(TBX_URL)
if u=="" then return nil end
return (u:gsub("/+$",""))
end
local function isLocal() return base()==nil or REQ==nil end
local function ownerKey()
local str=tostring(LP.UserId) .. ":hax-animator-salt-7Qx2"
local h1,h2=5381,52711
for i=1,#str do
local c=str:byte(i)
h1=(h1*33+c)%4294967296
h2=(h2*131+c*7+i)%4294967296
end
return string.format("%08x%08x",h1,h2)
end
local function errMsg(st)
if st==401 or st==403 then return "Firebase bloqueou (403): cole as Rules no console do Firebase" end
if st==0 then return "Sem conexão (URL errada ou request bloqueado)" end
return "Falha HTTP " .. tostring(st)
end
local function lget(path)
local cur=DB.tbx
for p in path:gmatch("[^/]+") do
if type(cur)~="table" then return nil end
cur=cur[p]
end
return cur
end
local function lset(path,val)
DB.tbx=DB.tbx or {}
local cur,parts=DB.tbx,{}
for p in path:gmatch("[^/]+") do parts[#parts+1]=p end
for i=1,#parts-1 do
if type(cur[parts[i]])~="table" then cur[parts[i]]={} end
cur=cur[parts[i]]
end
cur[parts[#parts]]=val
end
local function http(method,path,body,hdr)
local u=base()
if not u or not REQ then return false,0,nil end
local h={["Content-Type"]="application/json"}
if hdr then for k,v in pairs(hdr) do h[k]=v end end
local ok,res=pcall(REQ,{Url=u .. "/" .. path .. ".json",Method=method,Headers=h,Body=(body~=nil) and HttpService:JSONEncode(body) or nil})
if not ok or type(res)~="table" then return false,0,nil end
local st=res.StatusCode or 0
local data
if type(res.Body)=="string" and res.Body~="" then
local o,d=pcall(function() return HttpService:JSONDecode(res.Body) end)
if o then data=d end
end
return (st>=200 and st<300),st,data
end
function B.get(path)
if isLocal() then return true,lget(path),200 end
local ok,st,d=http("GET",path)
return ok,d,st
end
function B.put(path,val,onlyNew)
if isLocal() then
if onlyNew and lget(path)~=nil then return false,412 end
lset(path,val); dbSave()
return true,200
end
return http("PUT",path,val,onlyNew and {["if-match"]="null_etag"} or nil)
end
function B.del(path)
if isLocal() then lset(path,nil); dbSave(); return true end
return (http("DELETE",path))
end
local function genId()
while true do
local t,hasLetter={},false
for i=1,7 do
local n=math.random(1,#ID_CH)
t[i]=ID_CH:sub(n,n)
if n<=26 then hasLetter=true end
end
if hasLetter then return table.concat(t) end
end
end
local function publish(nm,isPub,rec)
local data=HttpService:JSONEncode(rec)
for _=1,8 do
local id=genId()
local meta={name=nm,author=LP.Name,uid=LP.UserId,time=os.time()}
local ok,st=B.put("store/" .. id,{name=nm,author=LP.Name,uid=LP.UserId,time=meta.time,pub=isPub,data=data},true)
if ok then
if isPub then B.put("public/" .. id,meta) end
B.put("users/" .. ownerKey() .. "/" .. id,{name=nm,pub=isPub,time=meta.time})
return id
elseif st~=412 then
return nil,errMsg(st)
end
end
return nil,"Não consegui gerar um ID único"
end
local function insertById(id)
local ok,rec,st=B.get("store/" .. id)
if not ok then say(errMsg(st),true); return false end
if type(rec)~="table" or type(rec.data)~="string" then say("Animação não encontrada",true); return false end
local o,d=pcall(function() return HttpService:JSONDecode(rec.data) end)
if not o or type(d)~="table" or type(d.tracks)~="table" then say("Dados inválidos",true); return false end
for _,p in ipairs(PARTS) do
if type(d.tracks[p])=="table" and #d.tracks[p]>1500 then say("Animação grande demais",true); return false end
end
if type(d.xs)=="table" and #d.xs>80 then say("Animação grande demais",true); return false end
deserialize(d)
local nm=tostring(rec.name or d.name or "Toolbox")
if #nm>40 then nm=nm:sub(1,40) end
local b2,n=nm,2
S.name=nm
while DB.anims[S.name] do S.name=b2 .. " (" .. n .. ")"; n=n+1 end
DB.anims[S.name]=serialize(); dbSave()
nameBox.Text=S.name
S.tbxOpen(false)
rebuildFilesList(); rebuildTL(); applyPose(0); refreshProps()
toast("Inserida: " .. S.name)
return true
end
local function copyId(id)
if typeof(setclipboard)=="function" then setclipboard("#" .. id); say("ID copiado: #" .. id) else say("ID: #" .. id) end
end
S.tbxAPI={publish=publish,insertById=insertById,B=B,genId=genId,ownerKey=ownerKey}

local TP=new("Frame",{Position=UO(0,TITLE_H),Size=PANEL_SIZE,Visible=false,ZIndex=20,Active=true},W)
paint(TP,"bg")
S.TP=TP; S.reg(TP)
lbl(TP,"TOOLBOX",8,4,80,20,12,true)
stat=lbl(TP,"",88,4,280,20,10,false,"sub")
local clB=btn(TP,"Fechar",0,4,60,20,function() TP.Visible=false end,"accent")
clB.Position=UN(1,-68,0,4)
local tabs,pages={},{}
local refreshExplore,refreshMine,refreshSaved
local function showTab(i)
for j,p in ipairs(pages) do p.Visible=(j==i) end
for j,t in ipairs(tabs) do setOn(t[1],t[2],j==i) end
say(isLocal() and "modo local (só neste aparelho)" or ("servidor: " .. (base():match("//([^/]+)") or "?")))
if i==1 then refreshExplore() elseif i==2 then refreshMine() elseif i==4 then refreshSaved() end
end
local names={"Explorar","Meus","Por ID","+Upload"}
for i,nm in ipairs(names) do
local b,e=btn(TP,nm,8+(i-1)*106,28,102,20,function() showTab(i) end,nil,FT.GothamBold,10)
tabs[i]={b,e}
local pg=new("Frame",{Position=UO(8,54),Size=UN(1,-16,1,-60),BackgroundTransparency=1,Visible=false},TP)
pages[i]=pg
end
local function mkList(parent,pos,size)
local sc=new("ScrollingFrame",{Position=pos,Size=size,ScrollBarThickness=3,CanvasSize=UN(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},parent)
paint(sc,"bg2"); round(sc,5)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},sc)
new("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,3)},sc)
return sc
end
local function clearList(sc)
for _,c in ipairs(sc:GetChildren()) do
if c:IsA("GuiObject") then c:Destroy() end
end
end
local function emptyMsg(sc,text)
local t=TH()
new("TextLabel",{Size=UN(1,-8,0,26),BackgroundTransparency=1,Text=text,Font=FT.Gotham,TextSize=10,TextColor3=t.sub},sc)
end
local function rowBtn(sc,h,i)
local t=TH()
local r=new("TextButton",{Size=UN(1,-8,0,h),LayoutOrder=i,Text="",AutoButtonColor=false,[BC]=t.bg3},sc)
round(r,5)
return r
end
local function rowLbl(r,text,x,y,w,size,bold,col)
local t=TH()
return new("TextLabel",{Position=UO(x,y),Size=UO(w,16),BackgroundTransparency=1,Text=text,Font=bold and FT.GothamBold or FT.Gotham,TextSize=size,TextColor3=col or t.text,TextXAlignment=XL},r)
end
local function smallBtn(r,text,pos,w,col,cb)
local b=new("TextButton",{Text=text,Position=pos,Size=UO(w,22),Font=FT.GothamBold,TextSize=10,TextColor3=RGB(255,255,255),[BC]=col},r)
round(b,5)
tap(b,cb)
return b
end
local function fmtDate(t) return os.date("%d/%m/%y",t) end

-- 1) Explorar (animacoes publicas)
local selId
local rowsX={}
local L1=mkList(pages[1],UO(0,0),UN(1,0,1,-28))
local function paintRowsX()
local t=TH()
for id,r in pairs(rowsX) do r[BC]=(id==selId) and t.accent2 or t.bg3 end
end
refreshExplore=function()
clearList(L1); rowsX={}; selId=nil
local ok,d,st=B.get("public")
if not ok then say(errMsg(st),true); return end
local list={}
if type(d)=="table" then
for id,m in pairs(d) do
if type(m)=="table" then list[#list+1]={id=id,name=tostring(m.name or "?"),author=tostring(m.author or "?"),time=tonumber(m.time) or 0} end
end
end
table.sort(list,function(a,b) return a.time>b.time end)
if #list==0 then emptyMsg(L1,"Nenhuma animação pública ainda") end
local t=TH()
for i,it in ipairs(list) do
if i>100 then break end
local r=rowBtn(L1,34,i)
rowLbl(r,it.name,8,2,260,11,true)
rowLbl(r,"por " .. it.author .. "  |  " .. fmtDate(it.time),8,17,300,9,false,t.sub)
rowsX[it.id]=r
tap(r,function() selId=it.id; paintRowsX() end)
end
say(#list .. " animação(ões) pública(s)")
end
local rb=btn(pages[1],"Atualizar",0,0,90,22,function() refreshExplore() end)
rb.Position=UN(0,0,1,-24)
local ib=btn(pages[1],"Insert Anim",0,0,110,22,function()
if not selId then say("Selecione uma animação na lista",true); return end
insertById(selId)
end,"accent")
ib.Position=UN(0,96,1,-24)

-- 2) Meus uploads
local L2=mkList(pages[2],UO(0,0),UN(1,0,1,0))
refreshMine=function()
clearList(L2)
local uid=ownerKey()
local ok,d,st=B.get("users/" .. uid)
if not ok then say(errMsg(st),true); return end
local list={}
if type(d)=="table" then
for id,m in pairs(d) do
if type(m)=="table" then list[#list+1]={id=id,name=tostring(m.name or "?"),pub=m.pub==true,time=tonumber(m.time) or 0} end
end
end
table.sort(list,function(a,b) return a.time>b.time end)
if #list==0 then emptyMsg(L2,"Você ainda não publicou nada") end
local t=TH()
for i,it in ipairs(list) do
local r=new("Frame",{Size=UN(1,-8,0,40),LayoutOrder=i,[BC]=t.bg3},L2)
round(r,5)
rowLbl(r,it.name,8,3,190,11,true)
rowLbl(r,it.pub and "Público" or "Privado",8,21,60,10,it.pub==false,it.pub and t.sub or t.accent)
rowLbl(r,"#" .. it.id,70,21,120,10,false,t.sub)
smallBtn(r,"ID",UN(1,-172,0,9),36,RGB(70,74,100),function() copyId(it.id) end)
smallBtn(r,"Insert",UN(1,-132,0,9),52,t.accent2,function() insertById(it.id) end)
smallBtn(r,"Apagar",UN(1,-76,0,9),56,RGB(160,44,44),function()
local ok1=B.del("store/" .. it.id)
B.del("public/" .. it.id)
B.del("users/" .. uid .. "/" .. it.id)
refreshMine()
say(ok1 and ("Apagada: " .. it.name) or "Removida da sua lista (o servidor mantém a publicação)")
end)
end
say(#list .. " upload(s)")
end

-- 3) Por ID
local foundId
local idBox=tbox(pages[3],"",0,4,250,function() end)
idBox.PlaceholderText="#AE0F62O"
local card=lbl(pages[3],"Digite o ID único (ex: #AE0F62O) e toque em Buscar",0,34,420,64,11,false,"sub")
card.TextWrapped=true; card.TextYAlignment=Enum.TextYAlignment.Top
btn(pages[3],"Buscar",258,4,80,20,function()
local id=trim(idBox.Text):upper():gsub("[^A-Z0-9]","")
foundId=nil
if #id<4 then card.Text="ID inválido"; return end
local ok,rec,st=B.get("store/" .. id)
if not ok then card.Text=errMsg(st); return end
if type(rec)~="table" or type(rec.data)~="string" then card.Text="Nenhuma animação com o ID #" .. id; return end
foundId=id
card.Text=tostring(rec.name or "?") .. "\npor " .. tostring(rec.author or "?") .. "  |  " .. (rec.pub and "Pública" or "Privada") .. "  |  #" .. id
end,"accent")
local ib3=btn(pages[3],"Insert Anim",0,0,120,24,function()
if not foundId then say("Busque um ID primeiro",true); return end
insertById(foundId)
end,"accent")
ib3.Position=UN(0,0,0,104)

-- 4) +Upload
local upSel,upPublic,lastId=nil,true,nil
local L4=mkList(pages[4],UO(0,0),UO(200,150))
local rowsU={}
local upName
refreshSaved=function()
clearList(L4); rowsU={}
local ns={}
for n in pairs(DB.anims) do ns[#ns+1]=n end
table.sort(ns)
if #ns==0 then emptyMsg(L4,"Salve uma animação primeiro (Arquivo)") end
local t=TH()
for i,n in ipairs(ns) do
local r=rowBtn(L4,24,i)
rowLbl(r,n,8,4,180,11,true)
rowsU[n]=r
tap(r,function()
upSel=n
for k,rr in pairs(rowsU) do rr[BC]=(k==n) and t.accent2 or t.bg3 end
upName.Text=n
end)
end
end
lbl(pages[4],"Nome",208,0,100,16,10,false,"sub")
upName=tbox(pages[4],"",208,16,212,function() end)
lbl(pages[4],"Visibilidade",208,42,100,16,10,false,"sub")
local pubB,pubE,prvB,prvE
pubB,pubE=btn(pages[4],"Pública",208,58,104,22,function() upPublic=true; setOn(pubB,pubE,true); setOn(prvB,prvE,false) end)
prvB,prvE=btn(pages[4],"Privada",316,58,104,22,function() upPublic=false; setOn(pubB,pubE,false); setOn(prvB,prvE,true) end)
setOn(pubB,pubE,true)
local resLbl=lbl(pages[4],"",208,114,212,36,11,true)
resLbl.TextWrapped=true; resLbl.TextYAlignment=Enum.TextYAlignment.Top
btn(pages[4],"Publicar",208,86,212,24,function()
if not upSel or not DB.anims[upSel] then say("Escolha uma animação salva na lista",true); return end
local nm=trim(upName.Text)
if nm=="" then nm=upSel end
nm=nm:sub(1,40)
say("Publicando...")
local id,err=publish(nm,upPublic,DB.anims[upSel])
if not id then say(err or "Falha ao publicar",true); return end
lastId=id
resLbl.Text=(upPublic and "Publicada (pública)!" or "Publicada (privada)!") .. "\nID: #" .. id
say("Publicada: " .. nm)
end,"accent")
btn(pages[4],"Copiar ID",208,154,212,22,function() if lastId then copyId(lastId) else say("Publique primeiro",true) end end)

-- 5) Servidor
S.tbxOpen=function(on)
closeDD()
for _,pp in ipairs(S.panels) do if pp~=TP then pp.Visible=false end end
if on==nil then on=not TP.Visible end
TP.Visible=on
if on then showTab(1) end
end
end)()
;(function()
local EP=new("Frame",{Position=UO(0,TITLE_H),Size=PANEL_SIZE,Visible=false,ZIndex=20,Active=true},W)
paint(EP,"bg")
S.EP=EP; S.reg(EP)
lbl(EP,"EXPLORER (Parts / VFX)",8,4,200,20,12,true)
local stat=lbl(EP,"Toque num item e em Add",190,4,180,20,10,false,"sub")
local clB=btn(EP,"Fechar",0,4,60,20,function() EP.Visible=false end,"accent")
clB.Position=UN(1,-68,0,4)
local flt=tbox(EP,"",8,28,250,function() end)
S.setPh(flt,"buscar por nome/classe (ex: Beam)")
local LST=new("ScrollingFrame",{Position=UO(8,52),Size=UN(1,-16,1,-84),ScrollBarThickness=3,CanvasSize=UN(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},EP)
paint(LST,"bg2"); round(LST,5)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},LST)
new("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,3)},LST)
local exSel,exOpen,rowsE={}, {}, {}
exSel=nil
local function isRoot(inst)
for _,r in ipairs(S.xroots) do
if r.inst==inst then return true end
end
return false
end
local function flat(q)
local out={}
if q~="" then
for _,d in ipairs(workspace:GetDescendants()) do
if #out>=120 then break end
if d.Name:lower():find(q,1,true) or d.ClassName:lower():find(q,1,true) then out[#out+1]={inst=d,depth=0} end
end
return out
end
local function walk(inst,depth)
for _,c in ipairs(inst:GetChildren()) do
if #out>=250 then return end
out[#out+1]={inst=c,depth=depth,kids=#c:GetChildren()>0}
if exOpen[c] and depth<12 then walk(c,depth+1) end
end
end
walk(workspace,0)
return out
end
local refresh
local function paintSel()
local t=TH()
for inst,r in pairs(rowsE) do r[BC]=(inst==exSel) and t.accent2 or t.bg3 end
end
refresh=function()
for _,c in ipairs(LST:GetChildren()) do
if c:IsA("GuiObject") then c:Destroy() end
end
rowsE={}
local t=TH()
local q=(flt.Text:gsub("^%s+",""):gsub("%s+$","")):lower()
local list=flat(q)
for i,it in ipairs(list) do
local inst=it.inst
local r=new("TextButton",{Size=UN(1,-8,0,22),LayoutOrder=i,Text="",[BC]=(inst==exSel) and t.accent2 or t.bg3},LST)
round(r,4)
rowsE[inst]=r
local xo=4+it.depth*10
if it.kids and q=="" then
local ab=new("TextButton",{Position=UO(xo,3),Size=UO(16,16),Text=exOpen[inst] and "-" or "+",Font=FT.GothamBold,TextSize=11,[BC]=t.bg2,TextColor3=t.text,ZIndex=3},r)
tap(ab,function() exOpen[inst]=(not exOpen[inst]) or nil; refresh() end)
end
local _,ch=X.classInfo(inst)
local tag=isRoot(inst) and (X.isR6(inst) and "  [Rig R6 - Second Anim]" or "  [Second Anim]") or ""
new("TextLabel",{Position=UO(xo+20,0),Size=UN(1,-(xo+24),1,0),[BT]=1,Text=inst.Name .. "  (" .. inst.ClassName .. ")" .. tag,Font=FT.Gotham,TextSize=10,TextColor3=(ch or isRoot(inst) or (inst:IsA("Model") and X.isR6(inst))) and t.text or t.sub,TextXAlignment=XL,TextTruncate=Enum.TextTruncate.AtEnd},r)
tap(r,function() exSel=inst; paintSel(); stat.Text="Selecionado: " .. inst.Name end)
end
if #list==0 then stat.Text="Nada encontrado" end
end
flt.FocusLost:Connect(function() refresh() end)
local addB=btn(EP,"Add",0,0,90,22,function()
if not exSel then stat.Text="Selecione um item na lista"; return end
if not S.rig then stat.Text="Escolha um rig primeiro (Select ou Rig)"; return end
if X.addRoot(exSel) then
stat.Text="Adicionado! Use o botão Second Anim"
rebuildTL(); refreshProps(); refresh()
else stat.Text="Já está no Second Anim" end
end,"accent")
addB.Position=UN(0,8,1,-26)
local rmB=btn(EP,"Remover",0,0,90,22,function()
if not exSel then stat.Text="Selecione a raiz adicionada"; return end
if X.removeRoot(exSel) then
if #S.xroots==0 then S.xmode=false end
if S.xmode==false and S.xmeta[S.sel] then S.sel="Torso" end
S.selKey=nil; S.selSet={}
stat.Text="Removido (valores restaurados)"
rebuildTL(); refreshProps(); refresh()
else stat.Text="Esse item não é uma raiz adicionada" end
end)
rmB.Position=UN(0,104,1,-26)
local upB=btn(EP,"Atualizar",0,0,90,22,function() refresh() end)
upB.Position=UN(0,200,1,-26)
function X.openExplorer()
closeDD()
local was=EP.Visible
for _,pp in ipairs(S.panels) do pp.Visible=false end
EP.Visible=not was
if EP.Visible then refresh() end
end

function X.openValues()
local id=S.sel
local mt=S.xmeta[id]
if not (mt and #mt.ch>0) then toast("Selecione um item com valores (Part, Beam, luz...)",true); return end
if needRig() then return end
closeDD()
local t=TH()
CATCH=new("TextButton",{Size=UN(1,0,1,0),[BT]=1,Text="",ZIndex=45},W)
tap(CATCH,closeDD)
local h=62+#mt.ch*26
local P=new("Frame",{Position=UO(WIN_W/2 - 130,40),Size=UO(260,h),[BC]=t.bg2,Active=true,ZIndex=46},CATCH)
round(P,6)
new("UIStroke",{Color=t.accent,Thickness=1.5},P)
local f=curF()
new("TextLabel",{Position=UO(8,4),Size=UO(244,18),[BT]=1,Text="Valores no frame " .. f .. ": " .. (mt.inst and mt.inst.Name or "?"),Font=FT.GothamBold,TextSize=11,TextColor3=t.text,TextXAlignment=XL,ZIndex=47},P)
local cur=X.evalChan(id,f)
local boxes={}
for i,n in ipairs(mt.ch) do
local y=28+(i - 1)*26
new("TextLabel",{Position=UO(8,y),Size=UO(110,22),[BT]=1,Text=(n=="Enabled") and "Enabled (1=on 0=off)" or n,Font=FT.Gotham,TextSize=10,TextColor3=t.sub,TextXAlignment=XL,ZIndex=47},P)
local b=new("TextBox",{Position=UO(122,y),Size=UO(128,22),Text=tostring(math.floor((cur[i] or 0)*1000+0.5)/1000),Font=FT.Gotham,TextSize=11,TextColor3=t.text,[BC]=t.bg3,ClearTextOnFocus=false,ZIndex=47},P)
round(b,5)
boxes[i]=b
end
local ap=new("TextButton",{Position=UO(8,h - 30),Size=UO(244,24),Text="Aplicar neste frame",Font=FT.GothamBold,TextSize=11,TextColor3=t.ttext,[BC]=t.accent,ZIndex=47},P)
round(ap,5)
tap(ap,function()
local k=getKey(id,f)
if k and locked(k) then closeDD(); toast("KF 0 é a posição inicial (travado)",true); return end
if not k and not S.autokey then closeDD(); toast("Sem keyframe aqui: use +KF",true); return end
pushUndo()
if not k then k=ensureKey(id,f) end
for i=1,#mt.ch do
local n=tonumber(boxes[i].Text)
if n then k["c" .. i]=n end
end
S.dirty=true
closeDD(); applyPose(S.cur); rebuildTL(); refreshProps()
end)
end
end)()
;(function()
X.pk=nil
moveCB[#moveCB+1]=function(i)
local d=X.pk
if d and d.drag and (i==d.drag.i or i.UserInputType==Enum.UserInputType.MouseMovement) then
if d.drag.k=="sv" then d.sv(i.Position.X,i.Position.Y) else d.hue(i.Position.X) end
end
end
endCB[#endCB+1]=function() if X.pk then X.pk.drag=nil end end
function X.pickColor(init,cb)
closeDD()
local t=TH()
local hh,ss,vv=init:ToHSV()
local h,sat,v=hh or 0,ss or 0,vv or 1
local cur=init
CATCH=new("TextButton",{Size=UN(1,0,1,0),[BT]=1,Text="",ZIndex=45},W)
tap(CATCH,function() X.pk=nil; closeDD() end)
local P=new("Frame",{Position=UO(WIN_W/2 - 140,30),Size=UO(280,172),[BC]=t.bg2,Active=true,ZIndex=46},CATCH)
round(P,6)
new("UIStroke",{Color=t.accent,Thickness=1.5},P)
local svb=new("Frame",{Position=UO(10,10),Size=UO(170,120),[BC]=Color3.fromHSV(h,1,1),Active=true,ZIndex=47},P)
local wh=new("Frame",{Size=UN(1,0,1,0),[BC]=Color3.new(1,1,1),ZIndex=48},svb)
new("UIGradient",{Transparency=NumberSequence.new(0,1)},wh)
local bk=new("Frame",{Size=UN(1,0,1,0),[BC]=Color3.new(0,0,0),ZIndex=49},svb)
new("UIGradient",{Rotation=90,Transparency=NumberSequence.new(1,0)},bk)
local svk=new("Frame",{AnchorPoint=AP5,Size=UO(12,12),[BC]=Color3.new(1,1,1),ZIndex=51},svb)
round(svk,6)
new("UIStroke",{Color=Color3.new(0,0,0),Thickness=1.5},svk)
local hb=new("Frame",{Position=UO(10,140),Size=UO(170,18),[BC]=Color3.new(1,1,1),Active=true,ZIndex=47},P)
new("UIGradient",{Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),
ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),
ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),
ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))})},hb)
local hk=new("Frame",{AnchorPoint=AP5,Size=UO(6,24),[BC]=Color3.new(1,1,1),ZIndex=50},hb)
new("UIStroke",{Color=Color3.new(0,0,0),Thickness=1.5},hk)
local pv=new("Frame",{Position=UO(192,10),Size=UO(78,40),[BC]=cur,ZIndex=47},P)
round(pv,5)
local hx=new("TextBox",{Position=UO(192,56),Size=UO(78,22),Text="",Font=FT.Gotham,TextSize=11,TextColor3=t.text,[BC]=t.bg3,ClearTextOnFocus=false,ZIndex=47},P)
round(hx,5)
local function upd()
cur=Color3.fromHSV(h,sat,v)
svb[BC]=Color3.fromHSV(h,1,1)
svk.Position=UN(sat,0,1 - v,0)
hk.Position=UN(h,0,0.5,0)
pv[BC]=cur
hx.Text=string.format("#%02X%02X%02X",math.floor(cur.R*255+0.5),math.floor(cur.G*255+0.5),math.floor(cur.B*255+0.5))
end
local function setSV(px,py)
local ap,az=svb.AbsolutePosition,svb.AbsoluteSize
sat=math.clamp((px - ap.X)/math.max(az.X,1),0,1)
v=1 - math.clamp((py - ap.Y)/math.max(az.Y,1),0,1)
upd()
end
local function setHue(px)
local ap,az=hb.AbsolutePosition,hb.AbsoluteSize
h=math.clamp((px - ap.X)/math.max(az.X,1),0,0.999)
upd()
end
X.pk={drag=nil,sv=setSV,hue=setHue}
svb.InputBegan:Connect(function(i)
if isPress(i) then X.pk.drag={k="sv",i=i}; setSV(i.Position.X,i.Position.Y) end
end)
hb.InputBegan:Connect(function(i)
if isPress(i) then X.pk.drag={k="hue",i=i}; setHue(i.Position.X) end
end)
hx.FocusLost:Connect(function()
local hexs=(hx.Text:gsub("[^%x]",""))
if #hexs==6 then
local r,g,b=tonumber(hexs:sub(1,2),16),tonumber(hexs:sub(3,4),16),tonumber(hexs:sub(5,6),16)
if r and g and b then
local h2,s2,v2=Color3.fromRGB(r,g,b):ToHSV()
h,sat,v=h2 or 0,s2 or 0,v2 or 1
end
end
upd()
end)
local ok=new("TextButton",{Position=UO(192,86),Size=UO(78,26),Text="Aplicar",Font=FT.GothamBold,TextSize=11,TextColor3=t.ttext,[BC]=t.accent,ZIndex=47},P)
round(ok,5)
tap(ok,function() local c=cur; X.pk=nil; closeDD(); cb(c) end)
local no=new("TextButton",{Position=UO(192,118),Size=UO(78,26),Text="Cancelar",Font=FT.GothamBold,TextSize=11,TextColor3=t.text,[BC]=t.bg3,ZIndex=47},P)
round(no,5)
tap(no,function() X.pk=nil; closeDD() end)
upd()
end
end)()

;(function()
local IKP=new("Frame",{Position=UO(0,TITLE_H),Size=PANEL_SIZE,Visible=false,ZIndex=20,Active=true},W)
paint(IKP,"bg"); S.reg(IKP)
lbl(IKP,"IK  -  MEMBROS DO RIG",8,4,250,20,12,true)
local clB=btn(IKP,"Fechar",0,4,60,20,function() IKP.Visible=false end,"accent")
clB.Position=UN(1,-68,0,4)
local onB,onE
onB,onE=btn(IKP,"IK",8,28,56,22,function() S.ik=not S.ik; X.ikRefresh() end,nil,FT.GothamBold,11)
btn(IKP,"Soltar todos",70,28,96,22,function() S.pins={}; S.pins15={}; X.ikRefresh(); toast("Todas as pontas soltas") end)
local stat=lbl(IKP,"",172,28,262,22,9,false,"sub")
stat.TextWrapped=true
local LST=new("ScrollingFrame",{Position=UO(8,56),Size=UN(1,-16,1,-64),ScrollBarThickness=3,CanvasSize=UN(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},IKP)
paint(LST,"bg2"); round(LST,5)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},LST)
new("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,3)},LST)
local order=0
local function row(text,on,fn)
order=order+1
local t=TH()
local b=new("TextButton",{Size=UN(1,-8,0,24),LayoutOrder=order,Text="  " .. text,Font=FT.GothamBold,TextSize=11,TextColor3=on and t.ttext or t.text,[BC]=on and t.accent or t.bg3,TextXAlignment=XL},LST)
round(b,4)
tap(b,fn)
end
local function head(text)
order=order+1
local t=TH()
new("TextLabel",{Size=UN(1,-8,0,18),LayoutOrder=order,[BT]=1,Text="  " .. text,Font=FT.GothamBold,TextSize=10,TextColor3=t.sub,TextXAlignment=XL},LST)
end
function X.ikRefresh()
setOn(onB,onE,S.ik)
if S.refreshIK then S.refreshIK() end
S.setT(stat,S.ik and "IK ligado: mexa/gire o torso e as pontas travadas ficam no lugar" or "IK desligado (as pontas travadas são ignoradas)")
for _,c in ipairs(LST:GetChildren()) do
if c:IsA("GuiObject") then c:Destroy() end
end
order=0
local any=false
if S.rig then
any=true
head("Rig: " .. S.rig.Name .. "  [R6]  (membro rígido: só se inclina)")
for _,id in ipairs({"Head","Right Arm","Left Arm","Right Leg","Left Leg"}) do
row(id .. (S.pins[id] and "   [TRAVADO]" or ""),S.pins[id]~=nil,function()
X.togglePin(id); X.ikRefresh()
end)
end
end
for _,r in ipairs(S.xrigs) do
if r.kind=="R15" then
any=true
head("Rig: " .. r.model.Name .. "  [R15]  (dobra joelho/cotovelo)")
for _,def in ipairs(X.R15CH) do
local pinned=r.ids[def[2]] and S.pins15[r.ids[def[2]]]~=nil
row(def[1] .. (pinned and "   [TRAVADO]" or ""),pinned,function()
X.toggle15(r,def); X.ikRefresh()
end)
end
end
end
if not any then head("Nenhum rig carregado. Use Select/Rig e toque no NPC (R6 ou R15).") end
end
function X.openIK()
closeDD()
local was=IKP.Visible
for _,pp in ipairs(S.panels) do pp.Visible=false end
IKP.Visible=not was
if IKP.Visible then X.ikRefresh() end
end
end)()
;(function()
local KP=new("Frame",{Position=UO(0,TITLE_H),Size=PANEL_SIZE,Visible=false,ZIndex=20,Active=true},W)
paint(KP,"bg"); S.reg(KP)
lbl(KP,"IMPORTAR KEYFRAMESEQUENCE",8,4,250,20,12,true)
local clB=btn(KP,"Fechar",0,4,60,20,function() KP.Visible=false end,"accent")
clB.Position=UN(1,-68,0,4)
local stat=lbl(KP,"",8,50,424,14,10,false,"sub")
local flt=tbox(KP,"",8,28,200,function() end)
S.setPh(flt,"buscar KeyframeSequence...")
local LST=new("ScrollingFrame",{Position=UO(8,66),Size=UN(1,-16,1,-98),ScrollBarThickness=3,CanvasSize=UN(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},KP)
paint(LST,"bg2"); round(LST,5)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},LST)
new("UIPadding",{PaddingTop=UDim.new(0,3),PaddingLeft=UDim.new(0,3)},LST)
local all,sel,rowsK={},nil,{}
local function say2(m,err) stat.Text=L(m); stat.TextColor3=err and RGB(255,120,110) or TH().sub end
local refresh
local function scan()
say2("Escaneando o jogo...")
all={}
local ok,d=pcall(function() return game:GetDescendants() end)
if ok then
for _,o in ipairs(d) do
if o.ClassName=="KeyframeSequence" then
all[#all+1]=o
if #all>=300 then break end
end
end
end
end
function X.kfsToData(ks)
local tracks={}
for _,p in ipairs(PARTS) do tracks[p]={} end
local kfs={}
for _,c in ipairs(ks:GetChildren()) do
if c.ClassName=="Keyframe" then kfs[#kfs+1]=c end
end
table.sort(kfs,function(a,b) return a.Time<b.Time end)
local maxF,total,seen=0,0,{}
local EM={Linear="Linear",Constant="Constant",Elastic="Elastic",Bounce="Bounce",Cubic="Cubic",CubicV2="Cubic"}
local FLIP={In="Out",Out="In",InOut="InOut"}
for _,kf in ipairs(kfs) do
local f=math.floor(kf.Time*S.fps+0.5)
for _,pose in ipairs(kf:GetDescendants()) do
if pose.ClassName=="Pose" and tracks[pose.Name] and pose.Weight>0 and not seen[pose.Name .. "@" .. f] then
seen[pose.Name .. "@" .. f]=true
local cf=pose.CFrame
local rx,ry,rz=cf:ToEulerAnglesXYZ()
local pp=cf.Position
local oks,es=pcall(function() return pose.EasingStyle.Name end)
local okd,ed=pcall(function() return pose.EasingDirection.Name end)
table.insert(tracks[pose.Name],{f=f,px=pp.X,py=pp.Y,pz=pp.Z,rx=math.deg(rx),ry=math.deg(ry),rz=math.deg(rz),e=EM[oks and es or "Linear"] or "Linear",d=FLIP[okd and ed or "In"] or "In"})
total=total+1
if f>maxF then maxF=f end
end
end
end
if total==0 then return nil end
local prio="Action"
local okp,pn=pcall(function() return ks.Priority.Name end)
if okp and ({Idle=1,Movement=1,Action=1,Core=1})[pn] then prio=pn end
return {name=ks.Name,fps=S.fps,len=math.max(10,maxF),loop=ks.Loop==true,prio=prio,tracks=tracks}
end
local function uniqueName(nm)
local b2,n=nm,2
while DB.anims[nm] do nm=b2 .. " (" .. n .. ")"; n=n+1 end
return nm
end
local function paintSel()
local t=TH()
for o,r in pairs(rowsK) do r[BC]=(o==sel) and t.accent2 or t.bg3 end
end
refresh=function()
scan()
for _,c in ipairs(LST:GetChildren()) do
if c:IsA("GuiObject") then c:Destroy() end
end
rowsK={}
local t=TH()
local q=(flt.Text:gsub("^%s+",""):gsub("%s+$","")):lower()
local shown=0
for i,o in ipairs(all) do
local path=X.pathOf(o)
local short=table.concat(path,"/",math.max(1,#path - 3),#path - 1)
if q=="" or o.Name:lower():find(q,1,true) or short:lower():find(q,1,true) then
shown=shown+1
local r=new("TextButton",{Size=UN(1,-8,0,24),LayoutOrder=i,Text="",[BC]=(o==sel) and t.accent2 or t.bg3},LST)
round(r,4)
rowsK[o]=r
new("TextLabel",{Position=UO(6,0),Size=UN(1,-12,1,0),[BT]=1,Text=o.Name .. "   (" .. short .. ")",Font=FT.Gotham,TextSize=10,TextColor3=t.text,TextXAlignment=XL,TextTruncate=Enum.TextTruncate.AtEnd},r)
tap(r,function() sel=o; paintSel() end)
end
end
say2(shown .. " KeyframeSequence encontrada(s)")
end
flt.FocusLost:Connect(function() refresh() end)
local function convert()
if not sel then say2("Selecione uma KeyframeSequence na lista",true); return nil end
local d=X.kfsToData(sel)
if not d then say2("Nenhum membro R6 nessa animação (R15?)",true); return nil end
d.name=uniqueName(d.name)
return d
end
local b1=btn(KP,"Importar no rig",0,0,130,22,function()
if not S.rig then say2("Escolha um rig primeiro (Select ou Rig)",true); return end
local d=convert()
if not d then return end
DB.autosave=serialize()
deserialize(d)
nameBox.Text=S.name
DB.anims[S.name]=serialize(); dbSave(); rebuildFilesList()
rebuildTL(); applyPose(0); refreshProps()
say2("Importada (a anterior ficou no autosave)")
end,"accent")
b1.Position=UN(0,8,1,-26)
local b2=btn(KP,"Só salvar",0,0,100,22,function()
local d=convert()
if not d then return end
DB.anims[d.name]=d; dbSave(); rebuildFilesList()
say2("Salva na lista de salvas")
end)
b2.Position=UN(0,144,1,-26)
local b3=btn(KP,"Atualizar",0,0,90,22,function() refresh() end)
b3.Position=UN(0,252,1,-26)
function X.openImporter()
closeDD()
local was=KP.Visible
for _,pp in ipairs(S.panels) do pp.Visible=false end
KP.Visible=not was
if KP.Visible then refresh() end
end
end)()
;(function()
X.PLAYER=[=[
-- Hax Animator: toca a animacao em loop neste rig (R6 ou R15)
local rig=script.Parent
local folder=rig:WaitForChild("HaxAnimations",10)
if not folder then return end
local hum=rig:FindFirstChildOfClass("Humanoid") or rig:FindFirstChildOfClass("AnimationController")
if not hum then return end
local isR15=hum:IsA("Humanoid") and hum.RigType==Enum.HumanoidRigType.R15
local ks
for _,k in ipairs(folder:GetChildren()) do
if k:IsA("KeyframeSequence") and (k:GetAttribute("R15")==true)==isR15 then ks=k break end
end
if not ks then return end
local animator=hum:FindFirstChildOfClass("Animator")
if not animator then animator=Instance.new("Animator"); animator.Parent=hum end
local anim=Instance.new("Animation")
anim.AnimationId=game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(ks)
local track=animator:LoadAnimation(anim)
track.Looped=ks.Loop
track.Priority=ks.Priority
track:Play()
]=]
function X.r15KFS(name,target)
local map={Torso="LowerTorso",Head="Head",["Right Arm"]="RightUpperArm",["Left Arm"]="LeftUpperArm",["Right Leg"]="RightUpperLeg",["Left Leg"]="LeftUpperLeg"}
local R15,R6={},{}
for part,pn in pairs(map) do
local pp=target:FindFirstChild(pn)
local mo=pp and pp:FindFirstChildOfClass("Motor6D")
if not (mo and S.c0 and S.c0[part]) then return nil end
R15[part]=mo.C0 - mo.C0.Position
R6[part]=S.c0[part] - S.c0[part].Position
end
local ks=Instance.new("KeyframeSequence")
ks.Name=name .. "_R15"; ks.Loop=S.loop
pcall(function() ks.Priority=Enum.AnimationPriority[S.prio] end)
local dur=playEnd()/S.fps
local times={}
for i=0,math.ceil(dur*60 - 1e-9) - 1 do times[#times+1]=i/60 end
times[#times+1]=dur
local function pose(nm,w,cf,parent)
local pz=Instance.new("Pose")
pz.Name=nm; pz.Weight=w
if cf then pz.CFrame=cf end
pcall(function() pz.EasingStyle=Enum.PoseEasingStyle.Linear; pz.EasingDirection=Enum.PoseEasingDirection.Out end)
pz.Parent=parent
return pz
end
for _,t in ipairs(times) do
local f=t*S.fps
local function conv(part)
local T6=evalPart(part,f)
local D=R6[part]*(T6 - T6.Position)*R6[part]:Inverse()
local T=R15[part]:Inverse()*D*R15[part]
if part=="Torso" then T=T+R15[part]:VectorToObjectSpace(R6[part]:VectorToWorldSpace(T6.Position)) end
return T
end
local kf=Instance.new("Keyframe")
kf.Time=t
local root=pose("HumanoidRootPart",0,nil,kf)
local low=pose("LowerTorso",1,conv("Torso"),root)
local up=pose("UpperTorso",0,nil,low)
pose("Head",1,conv("Head"),up)
pose("RightUpperArm",1,conv("Right Arm"),up)
pose("LeftUpperArm",1,conv("Left Arm"),up)
pose("RightUpperLeg",1,conv("Right Leg"),low)
pose("LeftUpperLeg",1,conv("Left Leg"),low)
kf.Parent=ks
end
ks.Parent=workspace
return ks
end
function X.addToRig(target,ksR6,name,direct)
local hum=target:FindFirstChildOfClass("Humanoid")
local isR15=hum and hum.RigType==Enum.HumanoidRigType.R15
local ksR15
if direct then
if not isR15 then return false,"Animação de R15: escolha um rig R15 como alvo" end
ksR15=ksR6; ksR6=nil
elseif isR15 then
ksR15=X.r15KFS(name,target)
if not ksR15 then return false,"Esse rig R15 não tem as juntas esperadas" end
end
local folder=target:FindFirstChild("HaxAnimations")
if folder then folder:Destroy() end
folder=Instance.new("Folder")
folder.Name="HaxAnimations"
folder.Parent=target
if ksR6 then
ksR6.Parent=folder
pcall(function() ksR6:SetAttribute("R15",false) end)
end
if ksR15 then
ksR15.Parent=folder
pcall(function() ksR15:SetAttribute("R15",true) end)
end
local old=target:FindFirstChild("HaxAnimPlayer")
if old then old:Destroy() end
local okS=pcall(function()
local sc=Instance.new("Script")
sc.Name="HaxAnimPlayer"
sc.Source=X.PLAYER
sc.Parent=target
end)
if not okS and typeof(setclipboard)=="function" then pcall(setclipboard,X.PLAYER) end
return true,okS
end
local function humanoidModels()
local out={}
for _,d in ipairs(workspace:GetDescendants()) do
if d:IsA("Humanoid") and d.Parent and d.Parent:FindFirstChild("HumanoidRootPart") then
out[#out+1]=d.Parent
if #out>=40 then break end
end
end
return out
end
function X.openExport()
closeDD()
local t=TH()
local addRig,target=true,S.rig
if not target then for _,r in ipairs(S.xrigs) do if r.kind=="R15" then target=r.model end end end
CATCH=new("TextButton",{Size=UN(1,0,1,0),[BT]=1,Text="",ZIndex=45},W)
tap(CATCH,closeDD)
local P=new("Frame",{Position=UO(WIN_W/2 - 150,34),Size=UO(300,176),[BC]=t.bg2,Active=true,ZIndex=46},CATCH)
round(P,6)
new("UIStroke",{Color=t.accent,Thickness=1.5},P)
new("TextLabel",{Position=UO(10,6),Size=UO(280,18),[BT]=1,Text="Exportar KeyframeSequence",Font=FT.GothamBold,TextSize=12,TextColor3=t.text,TextXAlignment=XL,ZIndex=47},P)
new("TextLabel",{Position=UO(10,26),Size=UO(280,30),[BT]=1,Text=S.expBake and "Assada: igual ao Play (60 Hz)" or "Só os keyframes",Font=FT.Gotham,TextSize=10,TextColor3=t.sub,TextXAlignment=XL,TextWrapped=true,ZIndex=47},P)
local cb=new("TextButton",{Position=UO(10,60),Size=UO(280,24),Text="",Font=FT.GothamBold,TextSize=11,TextColor3=t.text,[BC]=t.bg3,TextXAlignment=XL,ZIndex=47},P)
round(cb,5)
local function setCb() cb.Text="  " .. (addRig and "[X]" or "[  ]") .. "  Add to RIG" end
setCb()
tap(cb,function() addRig=not addRig; setCb() end)
local tb=new("TextButton",{Position=UO(10,90),Size=UO(280,24),Text="",Font=FT.Gotham,TextSize=10,TextColor3=t.text,[BC]=t.bg3,TextXAlignment=XL,ZIndex=47},P)
round(tb,5)
local function rigName(m)
if not m then return "(nenhum)" end
local h=m:FindFirstChildOfClass("Humanoid")
return m.Name .. ((h and h.RigType==Enum.HumanoidRigType.R15) and "  [R15]" or "  [R6]")
end
local function setTb() S.setT(tb,"  Rig alvo: " .. rigName(target)) end
setTb()
local cands=humanoidModels()
local ci=0
for i,m in ipairs(cands) do
if m==target then ci=i end
end
tap(tb,function()
if #cands==0 then toast("Nenhum rig R6 encontrado",true); return end
ci=ci % #cands+1
target=cands[ci]
setTb()
end)
local ok=new("TextButton",{Position=UO(10,128),Size=UO(136,32),Text="Confirmar",Font=FT.GothamBold,TextSize=12,TextColor3=t.ttext,[BC]=t.accent,ZIndex=47},P)
round(ok,5)
tap(ok,function()
closeDD()
local ks,direct,byModel=S.doExport()
if target and byModel and byModel[target] then ks=byModel[target]; direct=true end
if not ks then return end
if addRig and target then
local done,res=X.addToRig(target,ks,S.name,direct)
if not done then toast(res,true)
elseif res then toast("Adicionada ao rig (toca em loop ao entrar no jogo)")
else toast("Adicionada! Script copiado: cole num Script dentro do rig") end
end
end)
local no=new("TextButton",{Position=UO(154,128),Size=UO(136,32),Text="Cancelar",Font=FT.GothamBold,TextSize=12,TextColor3=t.text,[BC]=t.bg3,ZIndex=47},P)
round(no,5)
tap(no,closeDD)
end
end)()
do
local x=4
local function menu(text,w,getItems)
local b
b=btn(MENUBAR,text,x,1,w,18,function() dropdown(b,getItems(),200,9) end,"bg",FT.GothamMedium,11)
x=x+w+2
end
menu("Arquivo",52,function()
return {
{label="Nova animação",fn=ACT.new},
{label="Salvar",fn=function() DB.anims[S.name]=serialize(); dbSave(); rebuildFilesList(); toast("Salvo: " .. S.name) end},
{label="Toolbox...",fn=function() S.tbxOpen() end},
{label="Abrir / Importar...",fn=function() rebuildFilesList(); showPanel(FP) end},
{label="Importar KeyframeSequence...",fn=function() X.openImporter() end},
{label="Copiar JSON",fn=function()
local json=HttpService:JSONEncode(serialize())
if typeof(setclipboard)=="function" then setclipboard(json); toast("JSON copiado")
else jsonBox.Text=json; rebuildFilesList(); showPanel(FP); toast("Sem clipboard: JSON na caixa") end
end},
{label="Exportar KeyframeSequence",fn=function() X.openExport() end},
{label="Restaurar autosave",fn=function()
if DB.autosave then
deserialize(DB.autosave); nameBox.Text=S.name
rebuildTL(); applyPose(0); refreshProps(); toast("Autosave restaurado")
else toast("Nenhum autosave",true) end
end},
}
end)
menu("Editar",46,function()
return {
{label="Desfazer",fn=ACT.undo},
{label="Refazer",fn=ACT.redo},
{label="Copiar keyframes/pose",fn=ACT.copy},
{label="Colar keyframes/pose",fn=ACT.paste},
{label="Limpar trilha selecionada",fn=ACT.clearTrack,danger=true},
{label="Limpar tudo",fn=ACT.clearAll,danger=true},
}
end)
menu("Keyframe",58,function()
return {
{label="Adicionar na trilha",fn=ACT.addKey},
{label="Adicionar em todas",fn=ACT.addAll},
{label="Select KFs (ligar/desligar)",fn=ACT.toggleSel},
{label="Selecionar todos",fn=function() ACT.selAll() end},
{label="Selecionar trilha atual",fn=function() ACT.selAll(true) end},
{label="Limpar seleção",fn=ACT.selNone},
{label="Duplicar seleção à direita",fn=ACT.dup},
{label="Apagar selecionados",fn=ACT.delKey},
{label="Remover de todas (frame atual)",fn=ACT.delAll},
{label="Mover keyframe  <  1 frame",fn=function() ACT.moveKey(-1) end},
{label="Mover keyframe  >  1 frame",fn=function() ACT.moveKey(1) end},
{label="Zerar pose",fn=ACT.zero},
{label="Aplicar easing em toda a trilha",fn=ACT.easeAll},
}
end)
menu("Opções",52,function()
return {
{label="Selecionar rig (tocar no NPC)",fn=function() setPicking(true) end},
{label="Explorer (Parts/VFX)...",fn=function() X.openExplorer() end},
{label="Configurações...",fn=function() showPanel(SP) end},
{label="Zoom +",fn=function() S.ppf=math.clamp(S.ppf+1,2,30); rebuildTL(); saveSettings() end},
{label="Zoom -",fn=function() S.ppf=math.clamp(S.ppf - 1,2,30); rebuildTL(); saveSettings() end},
{label="Soltar rig",fn=function() releaseRig(); refreshProps(); toast("Rig solto") end},
}
end)
local function mbtn(text,w,cb)
local b,e=btn(MENUBAR,text,x,1,w,18,cb,"bg3",FT.GothamBold,10)
x=x+w+2
return b,e
end
mbtn("Toolbox",54,function() S.tbxOpen() end)
local sb,se=mbtn("Select KFs",64,function() ACT.toggleSel() end)
S.selBtn={sb,se}
local cb2,ce2
cb2,ce2=mbtn("Config KF",60,function()
S.cfgMode=not S.cfgMode
if S.cfgMode and S.selMode then ACT.toggleSel() end
setOn(cb2,ce2,S.cfgMode)
toast(S.cfgMode and "Config KF: toque num keyframe para editar tempo e easing (vários: Select KFs, depois Config KF)" or "Config KF desligado")
end)
S.cfgBtn={cb2,ce2}
mbtn("Copiar",44,function() ACT.copy() end)
mbtn("Colar",38,function() ACT.paste() end)
end
conns[#conns+1]=UIS.InputChanged:Connect(function(i)
if isMove(i) then
for _,f in ipairs(moveCB) do
local ok,err=pcall(f,i)
if not ok then warn("[Hax Animator] " .. tostring(err)) end
end
end
end)
conns[#conns+1]=UIS.InputEnded:Connect(function(i)
if isPress(i) then
for _,f in ipairs(endCB) do
local ok,err=pcall(f,i)
if not ok then warn("[Hax Animator] " .. tostring(err)) end
end
end
end)
conns[#conns+1]=UIS.TouchTapInWorld:Connect(function(pos,processed)
if not processed then
local ok,err=pcall(onWorldTap,pos.X,pos.Y)
if not ok then warn("[Hax Animator] " .. tostring(err)) end
end
end)
local mStart
conns[#conns+1]=UIS.InputBegan:Connect(function(i,gp)
if not gp and i.UserInputType==Enum.UserInputType.MouseButton1 then mStart=V2(i.Position.X,i.Position.Y) end
end)
conns[#conns+1]=UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 and mStart then
local d=(V2(i.Position.X,i.Position.Y) - mStart).Magnitude
mStart=nil
if d<6 then pcall(onWorldTap,i.Position.X,i.Position.Y) end
end
end)
local acc=0
conns[#conns+1]=RunService.RenderStepped:Connect(function(dt)
if S.rig and not S.rig:IsDescendantOf(workspace) then S.rig=nil; S.motors={}; refreshProps() end
if S.playing then
S.cur=S.cur+math.min(dt,0.1)*S.fps
local pe=playEnd()
if S.cur>=pe then
if S.loop and pe>0 then S.cur=S.cur%pe
else S.cur=pe; applyPose(S.cur); setPlaying(false) end
end
updatePlayhead()
local x,cp=xOf(S.cur)*UISC.Scale,TL.CanvasPosition.X*UISC.Scale
if x<cp or x>cp+TL.AbsoluteSize.X - 10 then TL.CanvasPosition=V2(math.max(0,xOf(S.cur) - 20),0) end
end
if S.playing and next(S.motors) then applyPose(S.cur) end
local ok,err=pcall(updateGizmo)
if not ok then warn("[Hax Animator] gizmo: " .. tostring(err)) end
end)
conns[#conns+1]=RunService.Heartbeat:Connect(function(dt)
acc=acc+dt
if acc>0.25 then acc=0; stopTracks(); if next(S.motors) or #S.xrigs>0 then applyPose(S.cur) end end
end)
task.spawn(function()
while gui.Parent do
task.wait(20)
if S.autosave and S.dirty and not S.playing then
S.dirty=false
DB.autosave=serialize()
dbSave()
end
end
end)
local function closeAll()
if S.camType then pcall(function() workspace.CurrentCamera.CameraType=S.camType end); S.camType=nil end
pcall(function() RunService:UnbindFromRenderStep("HaxCamPin") end)
releaseRig()
for _,c in ipairs(conns) do c:Disconnect() end
if gui then gui:Destroy() end
ENV.__HaxAnimator=nil
_G.__HaxAnimator=nil
end
ENV.__HaxAnimator=closeAll
tap(bClose,closeAll)
if S.bgId~="" then S.BG.Image="rbxassetid://" .. S.bgId; S.BG.Visible=true end
applyLayout()
applyStyle()
refreshGizmoBtns()
rebuildTL()
rebuildFilesList()
refreshProps()

if not S.rig then toast("Toque em Select e depois no NPC R6 que quer animar") end
end
local __ok,__err=xpcall(__HAX_MAIN,function(e) return debug.traceback(tostring(e),2) end)
if not __ok then
warn("[Hax Animator] ERRO AO INICIAR: " .. tostring(__err))
pcall(function()
local g=Instance.new("ScreenGui")
g.Name="HaxAnimatorErro"; g.ResetOnSpawn=false; g.DisplayOrder=1000
g.Parent=(gethui and gethui()) or game:GetService("CoreGui")
local f=Instance.new("TextLabel")
f.Size=UDim2.new(0.92,0,0,130); f.Position=UDim2.new(0.04,0,0,40)
f.BackgroundColor3=Color3.fromRGB(70,12,12); f.TextColor3=Color3.new(1,1,1)
f.TextWrapped=true; f.TextSize=12; f.Font=Enum.Font.Code
f.TextXAlignment=Enum.TextXAlignment.Left; f.TextYAlignment=Enum.TextYAlignment.Top
f.Text="Hax Animator falhou ao iniciar:\n" .. string.sub(tostring(__err),1,600)
f.Parent=g
task.delay(90,function() g:Destroy() end)
end)
end
-- FIM
