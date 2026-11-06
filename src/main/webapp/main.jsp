<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.wayos.*"%>

<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NovelGame — เกมนิยายภาพ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:ital,wght@0,300;0,400;0,600;0,700;1,300&family=Noto+Serif+Thai:wght@300;400;600;700&family=Playfair+Display:ital,wght@0,700;1,500&display=swap" rel="stylesheet">
<style>
/* ===================== CSS VARIABLES / THEMES ===================== */
:root {
  --bg-primary: #0d0a1a;
  --bg-secondary: #130f24;
  --bg-card: rgba(255,255,255,0.04);
  --bg-card-hover: rgba(255,255,255,0.08);
  --accent-1: #e8a0d8;
  --accent-2: #a78bfa;
  --accent-3: #f9a8d4;
  --accent-glow: rgba(232,160,216,0.3);
  --text-primary: #f0eaff;
  --text-secondary: #b8aed4;
  --text-muted: #6b5f8a;
  --border: rgba(255,255,255,0.08);
  --border-accent: rgba(232,160,216,0.3);
  --particle-color: #e8a0d8;
  --hero-gradient: radial-gradient(ellipse at 20% 50%, rgba(167,139,250,0.2) 0%, transparent 60%),
                   radial-gradient(ellipse at 80% 20%, rgba(232,160,216,0.15) 0%, transparent 50%),
                   radial-gradient(ellipse at 60% 80%, rgba(249,168,212,0.1) 0%, transparent 40%);
  --section-tag-bg: rgba(232,160,216,0.15);
  --section-tag-color: var(--accent-1);
  --btn-primary: linear-gradient(135deg, var(--accent-2), var(--accent-1));
  --star-color: #f9a8d4;
  --badge-new: #f43f5e;
  --badge-hot: #f97316;
  --badge-rec: #8b5cf6;
  --season-label: "✨ ธีมปกติ";
  --overlay-pattern: url("data:image/svg+xml,%3Csvg width='40' height='40' xmlns='http://www.w3.org/2000/svg'%3E%3Ccircle cx='20' cy='20' r='1' fill='rgba(232,160,216,0.12)'/%3E%3C/svg%3E");
  --scrollbar-thumb: var(--accent-2);
  --logo-glow: rgba(167,139,250,0.6);
  --nav-blur: blur(20px);
  --transition-speed: 0.4s;
}

/* THEMES */
[data-theme="newyear"] {
  --bg-primary: #0a0a0f;
  --bg-secondary: #0f0d1a;
  --accent-1: #ffd700;
  --accent-2: #ff6b35;
  --accent-3: #ffe66d;
  --accent-glow: rgba(255,215,0,0.3);
  --text-primary: #fff9e6;
  --text-secondary: #d4c080;
  --particle-color: #ffd700;
  --hero-gradient: radial-gradient(ellipse at 30% 40%, rgba(255,107,53,0.25) 0%, transparent 60%),
                   radial-gradient(ellipse at 70% 60%, rgba(255,215,0,0.2) 0%, transparent 50%);
  --section-tag-bg: rgba(255,215,0,0.15);
  --section-tag-color: #ffd700;
  --btn-primary: linear-gradient(135deg, #ff6b35, #ffd700);
  --season-label: "🎆 ปีใหม่";
  --star-color: #ffd700;
  --logo-glow: rgba(255,215,0,0.7);
  --border-accent: rgba(255,215,0,0.3);
}

[data-theme="childrensday"] {
  --bg-primary: #fff8f0;
  --bg-secondary: #fff0e6;
  --bg-card: rgba(255,150,100,0.06);
  --bg-card-hover: rgba(255,150,100,0.12);
  --accent-1: #ff6b9d;
  --accent-2: #4ecdc4;
  --accent-3: #ffe66d;
  --accent-glow: rgba(255,107,157,0.25);
  --text-primary: #2d1b4e;
  --text-secondary: #6b4f72;
  --text-muted: #b08fc0;
  --border: rgba(0,0,0,0.06);
  --particle-color: #ff6b9d;
  --hero-gradient: radial-gradient(ellipse at 25% 50%, rgba(255,107,157,0.15) 0%, transparent 60%),
                   radial-gradient(ellipse at 75% 30%, rgba(78,205,196,0.15) 0%, transparent 50%);
  --section-tag-bg: rgba(255,107,157,0.12);
  --section-tag-color: #ff6b9d;
  --btn-primary: linear-gradient(135deg, #ff6b9d, #4ecdc4);
  --season-label: "🎈 วันเด็ก";
  --star-color: #ff6b9d;
  --logo-glow: rgba(255,107,157,0.5);
  --border-accent: rgba(255,107,157,0.3);
  --scrollbar-thumb: #ff6b9d;
}

[data-theme="valentine"] {
  --bg-primary: #1a0812;
  --bg-secondary: #200d18;
  --accent-1: #ff4d6d;
  --accent-2: #ff8fa3;
  --accent-3: #ffb3c1;
  --accent-glow: rgba(255,77,109,0.35);
  --text-primary: #ffe0e9;
  --text-secondary: #d4899a;
  --particle-color: #ff4d6d;
  --hero-gradient: radial-gradient(ellipse at 50% 30%, rgba(255,77,109,0.3) 0%, transparent 60%),
                   radial-gradient(ellipse at 20% 80%, rgba(255,143,163,0.2) 0%, transparent 50%);
  --section-tag-bg: rgba(255,77,109,0.15);
  --section-tag-color: #ff4d6d;
  --btn-primary: linear-gradient(135deg, #ff4d6d, #ff8fa3);
  --season-label: "💕 วาเลนไทน์";
  --star-color: #ff4d6d;
  --logo-glow: rgba(255,77,109,0.7);
  --border-accent: rgba(255,77,109,0.35);
}

[data-theme="chinesenewyear"] {
  --bg-primary: #1a0000;
  --bg-secondary: #2a0000;
  --accent-1: #ffd700;
  --accent-2: #cc0000;
  --accent-3: #ffec6e;
  --accent-glow: rgba(255,215,0,0.35);
  --text-primary: #fff8e1;
  --text-secondary: #ffcc80;
  --text-muted: #bf8040;
  --particle-color: #ffd700;
  --hero-gradient: radial-gradient(ellipse at 40% 40%, rgba(204,0,0,0.4) 0%, transparent 60%),
                   radial-gradient(ellipse at 70% 70%, rgba(255,215,0,0.25) 0%, transparent 50%);
  --section-tag-bg: rgba(255,215,0,0.15);
  --section-tag-color: #ffd700;
  --btn-primary: linear-gradient(135deg, #cc0000, #ffd700);
  --season-label: "🏮 ตรุษจีน";
  --star-color: #ffd700;
  --logo-glow: rgba(255,215,0,0.7);
  --border-accent: rgba(255,215,0,0.4);
  --scrollbar-thumb: #cc0000;
}

[data-theme="summer"] {
  --bg-primary: #001a2e;
  --bg-secondary: #002240;
  --accent-1: #00d2ff;
  --accent-2: #7df9ff;
  --accent-3: #ff9a56;
  --accent-glow: rgba(0,210,255,0.3);
  --text-primary: #e0f8ff;
  --text-secondary: #80cfe0;
  --particle-color: #7df9ff;
  --hero-gradient: radial-gradient(ellipse at 50% 70%, rgba(0,210,255,0.25) 0%, transparent 60%),
                   radial-gradient(ellipse at 80% 20%, rgba(255,154,86,0.2) 0%, transparent 50%);
  --section-tag-bg: rgba(0,210,255,0.12);
  --section-tag-color: #00d2ff;
  --btn-primary: linear-gradient(135deg, #00d2ff, #7df9ff);
  --season-label: "🌊 หน้าร้อน/ทะเล";
  --star-color: #7df9ff;
  --logo-glow: rgba(0,210,255,0.7);
  --border-accent: rgba(0,210,255,0.3);
}

[data-theme="songkran"] {
  --bg-primary: #0a1a2e;
  --bg-secondary: #0d2040;
  --accent-1: #00b4ff;
  --accent-2: #40cfff;
  --accent-3: #ffd166;
  --accent-glow: rgba(0,180,255,0.3);
  --text-primary: #e0f4ff;
  --text-secondary: #80c0d8;
  --particle-color: #40cfff;
  --hero-gradient: radial-gradient(ellipse at 30% 60%, rgba(0,180,255,0.25) 0%, transparent 60%),
                   radial-gradient(ellipse at 70% 30%, rgba(255,209,102,0.18) 0%, transparent 50%);
  --section-tag-bg: rgba(0,180,255,0.12);
  --section-tag-color: #00b4ff;
  --btn-primary: linear-gradient(135deg, #00b4ff, #ffd166);
  --season-label: "💦 สงกรานต์";
  --star-color: #40cfff;
  --logo-glow: rgba(0,180,255,0.6);
  --border-accent: rgba(0,180,255,0.3);
}

[data-theme="rainy"] {
  --bg-primary: #0b1015;
  --bg-secondary: #0f161c;
  --accent-1: #6ab0d4;
  --accent-2: #4a90a4;
  --accent-3: #a8d8ea;
  --accent-glow: rgba(106,176,212,0.25);
  --text-primary: #d8eef8;
  --text-secondary: #8ab0c8;
  --particle-color: #6ab0d4;
  --hero-gradient: radial-gradient(ellipse at 50% 0%, rgba(106,176,212,0.2) 0%, transparent 60%),
                   radial-gradient(ellipse at 20% 80%, rgba(74,144,164,0.15) 0%, transparent 50%);
  --section-tag-bg: rgba(106,176,212,0.12);
  --section-tag-color: #6ab0d4;
  --btn-primary: linear-gradient(135deg, #4a90a4, #6ab0d4);
  --season-label: "🌧 ฤดูฝน";
  --star-color: #6ab0d4;
  --logo-glow: rgba(106,176,212,0.5);
  --border-accent: rgba(106,176,212,0.3);
}

[data-theme="winter"] {
  --bg-primary: #070d18;
  --bg-secondary: #0a1220;
  --accent-1: #c8e6ff;
  --accent-2: #7cb9e8;
  --accent-3: #e8f4ff;
  --accent-glow: rgba(200,230,255,0.2);
  --text-primary: #e8f4ff;
  --text-secondary: #9ab8d4;
  --particle-color: #c8e6ff;
  --hero-gradient: radial-gradient(ellipse at 50% 30%, rgba(200,230,255,0.15) 0%, transparent 60%),
                   radial-gradient(ellipse at 80% 70%, rgba(124,185,232,0.12) 0%, transparent 50%);
  --section-tag-bg: rgba(200,230,255,0.1);
  --section-tag-color: #c8e6ff;
  --btn-primary: linear-gradient(135deg, #7cb9e8, #c8e6ff);
  --season-label: "❄️ ฤดูหนาว";
  --star-color: #c8e6ff;
  --logo-glow: rgba(200,230,255,0.5);
  --border-accent: rgba(200,230,255,0.25);
}

[data-theme="christmas"] {
  --bg-primary: #050f08;
  --bg-secondary: #071310;
  --accent-1: #22c55e;
  --accent-2: #ef4444;
  --accent-3: #fbbf24;
  --accent-glow: rgba(34,197,94,0.25);
  --text-primary: #e8fdf0;
  --text-secondary: #86c89a;
  --particle-color: #fbbf24;
  --hero-gradient: radial-gradient(ellipse at 30% 40%, rgba(239,68,68,0.2) 0%, transparent 60%),
                   radial-gradient(ellipse at 70% 60%, rgba(34,197,94,0.2) 0%, transparent 50%);
  --section-tag-bg: rgba(251,191,36,0.12);
  --section-tag-color: #fbbf24;
  --btn-primary: linear-gradient(135deg, #22c55e, #ef4444);
  --season-label: "🎄 คริสต์มาส";
  --star-color: #fbbf24;
  --logo-glow: rgba(34,197,94,0.6);
  --border-accent: rgba(251,191,36,0.3);
}

/* ===================== GLOBAL ===================== */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

html { scroll-behavior: smooth; }

body {
  font-family: 'Sarabun', sans-serif;
  background-color: var(--bg-primary);
  color: var(--text-primary);
  min-height: 100vh;
  overflow-x: hidden;
  transition: background-color 0.6s ease, color 0.6s ease;
}

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: var(--bg-secondary); }
::-webkit-scrollbar-thumb { background: var(--scrollbar-thumb, var(--accent-2)); border-radius: 3px; }

/* ===================== CANVAS PARTICLES ===================== */
#particle-canvas {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  opacity: 0.6;
}

/* ===================== NAVBAR ===================== */
.navbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
  padding: 0 clamp(1rem, 4vw, 3rem);
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(0,0,0,0.4);
  backdrop-filter: var(--nav-blur);
  -webkit-backdrop-filter: var(--nav-blur);
  border-bottom: 1px solid var(--border);
  transition: all 0.4s ease;
}

.nav-logo {
  font-family: 'Playfair Display', serif;
  font-size: 1.5rem;
  font-weight: 700;
  font-style: italic;
  background: linear-gradient(135deg, var(--accent-1), var(--accent-2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: none;
  letter-spacing: -0.02em;
  filter: drop-shadow(0 0 20px var(--logo-glow));
  transition: filter 0.4s ease;
}

.nav-links {
  display: flex;
  gap: 2rem;
  list-style: none;
}
.nav-links a {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-secondary);
  text-decoration: none;
  letter-spacing: 0.05em;
  transition: color 0.3s ease;
}
.nav-links a:hover { color: var(--accent-1); }

.nav-right { display: flex; align-items: center; gap: 1rem; }

.btn-submit-nav {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.5rem 1.25rem;
  border-radius: 50px;
  background: var(--btn-primary);
  color: #fff;
  font-family: 'Sarabun', sans-serif;
  font-size: 0.82rem;
  font-weight: 700;
  text-decoration: none;
  letter-spacing: 0.03em;
  box-shadow: 0 4px 20px var(--accent-glow);
  transition: all 0.3s ease;
  white-space: nowrap;
}
.btn-submit-nav:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 28px var(--accent-glow);
  opacity: 0.92;
}

/* ===================== HERO ===================== */
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: clamp(5rem, 10vh, 8rem) clamp(1rem, 5vw, 4rem) 4rem;
  text-align: center;
  overflow: hidden;
}
.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--hero-gradient);
  transition: background 0.6s ease;
  z-index: 1;
}
.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--overlay-pattern);
  opacity: 0.4;
  z-index: 1;
}
.hero-content { position: relative; z-index: 2; max-width: 700px; }

.hero-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--accent-1);
  background: var(--section-tag-bg);
  border: 1px solid var(--border-accent);
  padding: 0.4rem 1rem;
  border-radius: 20px;
  margin-bottom: 1.5rem;
  animation: fadeInDown 0.8s ease both;
  transition: all 0.4s ease;
}

.hero-title {
  font-family: 'Noto Serif Thai', serif;
  font-size: clamp(2.5rem, 7vw, 5rem);
  font-weight: 700;
  line-height: 1.1;
  margin-bottom: 1rem;
  animation: fadeInUp 0.8s 0.1s ease both;
}
.hero-title .gradient-text {
  background: linear-gradient(135deg, var(--accent-1), var(--accent-2), var(--accent-3));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  background-size: 200% 200%;
  animation: gradientShift 4s ease infinite;
  transition: background 0.6s ease;
  display: block;
}

@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.hero-sub {
  font-size: clamp(0.95rem, 2vw, 1.15rem);
  font-weight: 300;
  color: var(--text-secondary);
  line-height: 1.8;
  margin-bottom: 2.5rem;
  animation: fadeInUp 0.8s 0.2s ease both;
}

.hero-cta {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  animation: fadeInUp 0.8s 0.3s ease both;
}

.btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.85rem 2rem;
  border-radius: 50px;
  background: var(--btn-primary);
  color: #fff;
  font-family: 'Sarabun', sans-serif;
  font-size: 0.95rem;
  font-weight: 700;
  text-decoration: none;
  border: none;
  cursor: pointer;
  box-shadow: 0 8px 30px var(--accent-glow);
  transition: all 0.3s ease;
  letter-spacing: 0.02em;
}
.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 40px var(--accent-glow);
}

.btn-outline {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.85rem 2rem;
  border-radius: 50px;
  background: transparent;
  color: var(--text-primary);
  font-family: 'Sarabun', sans-serif;
  font-size: 0.95rem;
  font-weight: 600;
  text-decoration: none;
  border: 1.5px solid var(--border-accent);
  cursor: pointer;
  transition: all 0.3s ease;
}
.btn-outline:hover {
  border-color: var(--accent-1);
  color: var(--accent-1);
  background: var(--section-tag-bg);
}

.hero-stats {
  display: flex;
  gap: 2.5rem;
  justify-content: center;
  margin-top: 4rem;
  animation: fadeInUp 0.8s 0.4s ease both;
}
.stat { text-align: center; }
.stat-num {
  font-family: 'Noto Serif Thai', serif;
  font-size: 1.6rem;
  font-weight: 700;
  color: var(--accent-1);
  display: block;
  line-height: 1;
  margin-bottom: 0.2rem;
}
.stat-label {
  font-size: 0.75rem;
  color: var(--text-muted);
  letter-spacing: 0.05em;
}
.stat-divider {
  width: 1px;
  background: var(--border);
  align-self: stretch;
}

/* ===================== SCROLL INDICATOR ===================== */
.scroll-indicator {
  position: absolute;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-muted);
  font-size: 0.7rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  animation: bounce 2s ease infinite;
}
@keyframes bounce {
  0%, 100% { transform: translateX(-50%) translateY(0); }
  50% { transform: translateX(-50%) translateY(6px); }
}
.scroll-line {
  width: 1px;
  height: 40px;
  background: linear-gradient(to bottom, var(--accent-1), transparent);
}

/* ===================== MAIN CONTENT ===================== */
.main { position: relative; z-index: 2; }

/* ===================== SECTION ===================== */
.section {
  padding: clamp(3rem, 8vh, 6rem) clamp(1rem, 5vw, 4rem);
  max-width: 1400px;
  margin: 0 auto;
}

.section-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 2.5rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.section-left {}
.section-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--section-tag-color);
  background: var(--section-tag-bg);
  padding: 0.3rem 0.75rem;
  border-radius: 20px;
  margin-bottom: 0.6rem;
  border: 1px solid var(--border-accent);
  transition: all 0.4s ease;
}
.section-title {
  font-family: 'Noto Serif Thai', serif;
  font-size: clamp(1.5rem, 3.5vw, 2.2rem);
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1.2;
}
.section-title span {
  background: linear-gradient(135deg, var(--accent-1), var(--accent-2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  transition: background 0.4s ease;
}

.view-all {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--accent-1);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  padding-bottom: 2px;
  transition: all 0.3s ease;
  white-space: nowrap;
}
.view-all:hover { border-bottom-color: var(--accent-1); }

/* ===================== GAME CARDS ===================== */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(220px, 100%), 1fr));
  gap: 1.25rem;
}

.game-card {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  background: var(--bg-card);
  border: 1px solid var(--border);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.34,1.2,0.64,1);
  group: true;
}
.game-card:hover {
  transform: translateY(-6px) scale(1.01);
  border-color: var(--border-accent);
  box-shadow: 0 20px 50px rgba(0,0,0,0.3), 0 0 30px var(--accent-glow);
  background: var(--bg-card-hover);
}

.card-thumb {
  aspect-ratio: 3/4;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, var(--bg-secondary), var(--bg-primary));
}

.card-thumb-art {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 4rem;
  background: linear-gradient(135deg, var(--bg-secondary) 0%, var(--bg-primary) 100%);
  position: relative;
  overflow: hidden;
  transition: transform 0.4s ease;
}
.game-card:hover .card-thumb-art { transform: scale(1.05); }

.card-thumb-art::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 50% 30%, var(--accent-glow), transparent 70%);
  transition: background 0.4s ease;
}

.card-badge {
  position: absolute;
  top: 0.75rem;
  left: 0.75rem;
  font-size: 0.65rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 0.25rem 0.6rem;
  border-radius: 6px;
  color: #fff;
  z-index: 2;
}
.badge-new { background: var(--badge-new); }
.badge-hot { background: var(--badge-hot); }
.badge-rec { background: var(--badge-rec); }

.card-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 60%);
  z-index: 1;
}

.card-body {
  padding: 1rem;
}
.card-title {
  font-family: 'Noto Serif Thai', serif;
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 0.35rem;
  line-height: 1.4;
}
.card-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 0.75rem;
  color: var(--text-muted);
}
.card-rating {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: var(--star-color);
  font-weight: 600;
  transition: color 0.4s ease;
}
.card-genre {
  font-size: 0.7rem;
  padding: 0.15rem 0.5rem;
  border-radius: 4px;
  background: var(--section-tag-bg);
  color: var(--section-tag-color);
  border: 1px solid var(--border-accent);
  transition: all 0.4s ease;
}

/* ===================== FEATURED BANNER ===================== */
.featured-banner {
  position: relative;
  border-radius: 24px;
  overflow: hidden;
  padding: clamp(2rem, 5vw, 4rem);
  margin: 0 clamp(1rem, 5vw, 4rem) 2rem;
  min-height: 300px;
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, var(--bg-secondary) 0%, var(--bg-primary) 100%);
  border: 1px solid var(--border-accent);
  transition: all 0.6s ease;
}
.featured-banner::before {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--hero-gradient);
  transition: background 0.6s ease;
}
.featured-content { position: relative; z-index: 2; max-width: 500px; }
.featured-tag {
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--accent-1);
  background: var(--section-tag-bg);
  border: 1px solid var(--border-accent);
  padding: 0.3rem 0.75rem;
  border-radius: 20px;
  display: inline-block;
  margin-bottom: 1rem;
  transition: all 0.4s ease;
}
.featured-title {
  font-family: 'Noto Serif Thai', serif;
  font-size: clamp(1.5rem, 4vw, 2.5rem);
  font-weight: 700;
  line-height: 1.2;
  margin-bottom: 0.75rem;
}
.featured-desc {
  font-size: 0.9rem;
  color: var(--text-secondary);
  line-height: 1.7;
  margin-bottom: 1.5rem;
  font-weight: 300;
}
.featured-emoji {
  position: absolute;
  right: clamp(1rem, 8vw, 6rem);
  top: 50%;
  transform: translateY(-50%);
  font-size: clamp(5rem, 15vw, 10rem);
  opacity: 0.15;
  z-index: 1;
  user-select: none;
  filter: blur(2px);
}

/* ===================== SECTION DIVIDER ===================== */
.section-divider {
  height: 1px;
  background: linear-gradient(to right, transparent, var(--border-accent), transparent);
  margin: 0 clamp(1rem, 5vw, 4rem);
  transition: background 0.4s ease;
}

/* ===================== GENRE PILLS (category nav) ===================== */
.genre-nav {
  padding: 0 clamp(1rem, 5vw, 4rem);
  margin-bottom: 1rem;
  display: flex;
  gap: 0.75rem;
  overflow-x: auto;
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
}
.genre-nav::-webkit-scrollbar { display: none; }

.genre-pill {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.5rem 1.25rem;
  border-radius: 50px;
  border: 1.5px solid var(--border);
  background: var(--bg-card);
  color: var(--text-secondary);
  font-size: 0.85rem;
  font-family: 'Sarabun', sans-serif;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.3s ease;
}
.genre-pill:hover, .genre-pill.active {
  border-color: var(--accent-1);
  color: var(--accent-1);
  background: var(--section-tag-bg);
  box-shadow: 0 4px 20px var(--accent-glow);
}

/* ===================== STACK SECTIONS ===================== */
.stack-section {
  border-top: 1px solid var(--border);
  padding-top: 1rem;
}
.stack-section + .stack-section { margin-top: 0.5rem; }

.stack-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem clamp(1rem, 5vw, 4rem);
  cursor: pointer;
  user-select: none;
  transition: background 0.2s ease;
}
.stack-header:hover { background: var(--bg-card); }

.stack-header-left {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.stack-icon {
  width: 44px; height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.4rem;
  background: var(--section-tag-bg);
  border: 1px solid var(--border-accent);
  flex-shrink: 0;
  transition: all 0.4s ease;
}
.stack-header-title {
  font-family: 'Noto Serif Thai', serif;
  font-size: clamp(1.1rem, 2.5vw, 1.4rem);
  font-weight: 700;
  color: var(--text-primary);
}
.stack-header-sub {
  font-size: 0.8rem;
  color: var(--text-muted);
  margin-top: 0.1rem;
}
.stack-count {
  font-size: 0.75rem;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  background: var(--section-tag-bg);
  color: var(--section-tag-color);
  border: 1px solid var(--border-accent);
  font-weight: 700;
  transition: all 0.4s ease;
}
.stack-chevron {
  color: var(--text-muted);
  font-size: 1.2rem;
  transition: transform 0.3s ease;
  margin-left: 0.5rem;
}
.stack-header.open .stack-chevron { transform: rotate(180deg); }

.stack-body {
  overflow: hidden;
  max-height: 0;
  transition: max-height 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.stack-body.open { max-height: 2000px; }

.stack-body-inner {
  padding: 0 clamp(1rem, 5vw, 4rem) 2rem;
}

/* ===================== HORIZONTAL SCROLL SECTION ===================== */
.hscroll-wrap {
  overflow-x: auto;
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 0.5rem;
  margin: 0 -1rem;
  padding: 0.5rem 1rem;
}
.hscroll-wrap::-webkit-scrollbar { display: none; }
.hscroll-inner {
  display: flex;
  gap: 1.25rem;
  width: max-content;
}
.hscroll-inner .game-card {
  width: 200px;
  flex-shrink: 0;
}

/* ===================== FOOTER ===================== */
footer {
  position: relative;
  z-index: 2;
  padding: 3rem clamp(1rem, 5vw, 4rem);
  border-top: 1px solid var(--border);
  margin-top: 2rem;
}
.footer-inner {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  flex-wrap: wrap;
  gap: 2rem;
  justify-content: space-between;
  align-items: center;
}
.footer-logo {
  font-family: 'Playfair Display', serif;
  font-size: 1.3rem;
  font-weight: 700;
  font-style: italic;
  background: linear-gradient(135deg, var(--accent-1), var(--accent-2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  filter: drop-shadow(0 0 10px var(--logo-glow));
  transition: filter 0.4s ease;
}
.footer-copy {
  font-size: 0.8rem;
  color: var(--text-muted);
}
.footer-links {
  display: flex;
  gap: 1.5rem;
  list-style: none;
}
.footer-links a {
  font-size: 0.8rem;
  color: var(--text-muted);
  text-decoration: none;
  transition: color 0.3s ease;
}
.footer-links a:hover { color: var(--accent-1); }

/* ===================== ANIMATIONS ===================== */
@keyframes fadeInDown {
  from { opacity: 0; transform: translateY(-20px); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

.reveal {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.reveal.visible {
  opacity: 1;
  transform: none;
}
.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }

/* ===================== RESPONSIVE ===================== */
@media (max-width: 768px) {
  .nav-links { display: none; }
  .hero-stats { gap: 1.5rem; }
  .stat-divider { display: none; }
  .featured-emoji { display: none; }
}

@media (max-width: 500px) {
  .cards-grid { grid-template-columns: repeat(2, 1fr); gap: 0.75rem; }
  .hscroll-inner .game-card { width: 160px; }
}
</style>
</head>
<body>

<canvas id="particle-canvas"></canvas>

<!-- NAVBAR -->
<nav class="navbar">
  <div class="nav-logo">NovelGame</div>
  <ul class="nav-links">
    <li><a href="#romance-f" onclick="scrollToSection(event,'romance-f')">จีบสาว/หนุ่ม</a></li>
    <li><a href="#mystery" onclick="scrollToSection(event,'mystery')">สืบสวน</a></li>
    <li><a href="#dark" onclick="scrollToSection(event,'dark')">ลึกลับ</a></li>
    <li><a href="#yuri" onclick="scrollToSection(event,'yuri')">ยูริ</a></li>
  </ul>
  <div class="nav-right">
    <a href="#submit" class="btn-submit-nav">✦ ส่งผลงานเกม</a>
  </div>
</nav>

<!-- HERO -->
<section class="hero">
  <div class="hero-content">
    <div class="hero-eyebrow">✦ พอร์ทัลเกมนิยายภาพ ✦</div>
    <h1 class="hero-title">
      เปิดประตูสู่โลกแห่ง
      <span class="gradient-text">เรื่องราวที่คุณเลือก</span>
    </h1>
    <p class="hero-sub">สำรวจเกมนิยายภาพหลากหลายแนว<br>จีบสาว จีบหนุ่ม สืบสวน ลึกลับ และยูริ<br>ในที่เดียว อัปเดตทุกวัน</p>
    <div class="hero-cta">
      <a href="#games" class="btn-primary">🎮 เริ่มเล่นเลย</a>
      <a href="#newarrivals" class="btn-outline">✦ มาใหม่ล่าสุด</a>
    </div>
    <div class="hero-stats">
      <div class="stat">
        <span class="stat-num">1,240+</span>
        <span class="stat-label">เกมทั้งหมด</span>
      </div>
      <div class="stat-divider"></div>
      <div class="stat">
        <span class="stat-num">380K</span>
        <span class="stat-label">ผู้เล่นประจำ</span>
      </div>
      <div class="stat-divider"></div>
      <div class="stat">
        <span class="stat-num">99+</span>
        <span class="stat-label">นักพัฒนา</span>
      </div>
    </div>
  </div>
  <div class="scroll-indicator">
    <div class="scroll-line"></div>
    <span>เลื่อนลง</span>
  </div>
</section>

<main class="main" id="games">

  <!-- FEATURED -->
  <div class="featured-banner reveal">
    <div class="featured-content">
      <div class="featured-tag">⭐ แนะนำประจำสัปดาห์</div>
      <h2 class="featured-title">ใต้แสงจันทร์<br>กับนายร้ายที่ฉันรัก</h2>
      <p class="featured-desc">เมื่อนักสืบสาวพลาดไปตกหลุมรักกับเป้าหมายที่เธอต้องสืบสวน ในเมืองที่เต็มไปด้วยความลับและอันตราย...</p>
      <a href="#" class="btn-primary">▶ เล่นฟรีเลย</a>
    </div>
    <div class="featured-emoji">🌙</div>
  </div>

  <!-- GENRE NAV -->
  <div class="genre-nav" id="genre-nav">
    <button class="genre-pill active" onclick="filterGenre(this,'all')">🎮 ทั้งหมด</button>
    <button class="genre-pill" onclick="filterGenre(this,'romance-f')">💗 จีบสาว</button>
    <button class="genre-pill" onclick="filterGenre(this,'romance-m')">💙 จีบหนุ่ม</button>
    <button class="genre-pill" onclick="filterGenre(this,'mystery')">🔍 สืบสวน</button>
    <button class="genre-pill" onclick="filterGenre(this,'dark')">🌑 ลึกลับ</button>
    <button class="genre-pill" onclick="filterGenre(this,'yuri')">🌸 ยูริ</button>
    <button class="genre-pill" onclick="filterGenre(this,'new')">✨ มาใหม่</button>
    <button class="genre-pill" onclick="filterGenre(this,'hot')">🔥 ฮิต</button>
  </div>

  <!-- ====== STACK: เกมจีบสาว ====== -->
  <div class="stack-section" id="romance-f">
    <div class="stack-header open" onclick="toggleStack(this)">
      <div class="stack-header-left">
        <div class="stack-icon">💗</div>
        <div>
          <div class="stack-header-title">เกมจีบสาว</div>
          <div class="stack-header-sub">Otome & Romance · สำหรับทุกเพศ</div>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:0.75rem">
        <div class="stack-count">186 เกม</div>
        <div class="stack-chevron">▼</div>
      </div>
    </div>
    <div class="stack-body open">
<!--       <div class="stack-body-inner"> -->
<!--         <div class="hscroll-wrap"> -->
<!--           <div class="hscroll-inner"> -->
<!--             Cards -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌸</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ซากุระแห่งใจฉัน</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">โรแมนติก</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎀</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">เจ้าชายในฝัน</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">แฟนตาซี</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">☕</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">Café de Amour</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">ชีวิต</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎵</div><span class="card-badge badge-rec">แนะนำ</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">เสียงเพลงหัวใจ</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">ดนตรี</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌙</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">คืนเดือนเพ็ญ</div><div class="card-meta"><span class="card-rating">★ 4.5</span><span class="card-genre">โรแมนติก</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🦋</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ผีเสื้อสีทอง</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">แฟนตาซี</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌹</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">กุหลาบสีเลือด</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">ดราม่า</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">⭐</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ดาวห้าแฉกในใจ</div><div class="card-meta"><span class="card-rating">★ 4.4</span><span class="card-genre">โรแมนติก</span></div></div></div> -->
<!--           </div> -->
<!--         </div> -->
<!--         <div style="margin-top:1rem;text-align:right"><a href="#" class="view-all">ดูทั้งหมด 186 เกม →</a></div> -->
<!--       </div> -->
    </div>
  </div>

  <!-- ====== STACK: เกมจีบหนุ่ม ====== -->
  <div class="stack-section" id="romance-m">
    <div class="stack-header open" onclick="toggleStack(this)">
      <div class="stack-header-left">
        <div class="stack-icon">💙</div>
        <div>
          <div class="stack-header-title">เกมจีบหนุ่ม</div>
          <div class="stack-header-sub">BL & Reverse Harem · หลากหลายรสชาติ</div>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:0.75rem">
        <div class="stack-count">142 เกม</div>
        <div class="stack-chevron">▼</div>
      </div>
    </div>
    <div class="stack-body open">
<!--       <div class="stack-body-inner"> -->
<!--         <div class="hscroll-wrap"> -->
<!--           <div class="hscroll-inner"> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌊</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">คลื่นหัวใจ</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">BL</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎭</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">นักแสดงหน้ากาก</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">ดราม่า</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🗡️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">อัศวินแห่งรัตติกาล</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">แฟนตาซี</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎓</div><span class="card-badge badge-rec">แนะนำ</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">มหาลัยแห่งรัก</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">ชีวิต</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌌</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">จักรวาลของเรา</div><div class="card-meta"><span class="card-rating">★ 4.5</span><span class="card-genre">SF</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🏹</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ลูกศรแห่งโชคชะตา</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">แฟนตาซี</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎸</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">Band ลับหัวใจสั่น</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">ดนตรี</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌿</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">สวนลับแห่งรัก</div><div class="card-meta"><span class="card-rating">★ 4.4</span><span class="card-genre">ชีวิต</span></div></div></div> -->
<!--           </div> -->
<!--         </div> -->
<!--         <div style="margin-top:1rem;text-align:right"><a href="#" class="view-all">ดูทั้งหมด 142 เกม →</a></div> -->
<!--       </div> -->
    </div>
  </div>

  <!-- ====== STACK: เกมสืบสวน ====== -->
  <div class="stack-section" id="mystery">
    <div class="stack-header" onclick="toggleStack(this)">
      <div class="stack-header-left">
        <div class="stack-icon">🔍</div>
        <div>
          <div class="stack-header-title">เกมสืบสวน</div>
          <div class="stack-header-sub">Detective · Whodunit · Crime Thriller</div>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:0.75rem">
        <div class="stack-count">98 เกม</div>
        <div class="stack-chevron">▼</div>
      </div>
    </div>
    <div class="stack-body">
<!--       <div class="stack-body-inner"> -->
<!--         <div class="cards-grid"> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🔎</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">คดีปริศนาคืนฝน</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">สืบสวน</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🗂️</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">แฟ้มคดีลับ X</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">Noir</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">⚖️</div><span class="card-badge badge-rec">แนะนำ</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ศาลแห่งความจริง</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">กฎหมาย</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🏛️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">พิพิธภัณฑ์มรณา</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">Whodunit</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">📷</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">เลนส์มืดซ่อนความจริง</div><div class="card-meta"><span class="card-rating">★ 4.5</span><span class="card-genre">Thriller</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🚂</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ฆาตกรรมบนรถด่วน</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">Mystery</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🔐</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ห้องล็อคความลับ</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">Escape</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🧬</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">DNA แห่งการโกหก</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">Sci-Fi</span></div></div></div> -->
<!--         </div> -->
<!--         <div style="margin-top:1.5rem;text-align:right"><a href="#" class="view-all">ดูทั้งหมด 98 เกม →</a></div> -->
<!--       </div> -->
    </div>
  </div>

  <!-- ====== STACK: เกมลึกลับ ====== -->
  <div class="stack-section" id="dark">
    <div class="stack-header" onclick="toggleStack(this)">
      <div class="stack-header-left">
        <div class="stack-icon">🌑</div>
        <div>
          <div class="stack-header-title">เกมลึกลับ</div>
          <div class="stack-header-sub">Horror · Paranormal · Dark Fantasy</div>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:0.75rem">
        <div class="stack-count">74 เกม</div>
        <div class="stack-chevron">▼</div>
      </div>
    </div>
    <div class="stack-body">
<!--       <div class="stack-body-inner"> -->
<!--         <div class="cards-grid"> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">👁️</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ดวงตาที่สาม</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">Horror</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🕯️</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">แสงเทียนในมืด</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">Gothic</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌒</div><span class="card-badge badge-rec">แนะนำ</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">จันทร์เสี้ยวอาถรรพ์</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">Paranormal</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🧿</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ลูกตาปีศาจ</div><div class="card-meta"><span class="card-rating">★ 4.5</span><span class="card-genre">Occult</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">⛩️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ศาลเจ้าต้องคำสาป</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">Horror</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌀</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">วนซ้ำในฝันร้าย</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">Psychological</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🕷️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ใยแมงมุมวิญญาณ</div><div class="card-meta"><span class="card-rating">★ 4.4</span><span class="card-genre">Dark</span></div></div></div> -->
<!--           <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌫️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">หมอกแห่งความมืด</div><div class="card-meta"><span class="card-rating">★ 4.5</span><span class="card-genre">Atmospheric</span></div></div></div> -->
<!--         </div> -->
<!--         <div style="margin-top:1.5rem;text-align:right"><a href="#" class="view-all">ดูทั้งหมด 74 เกม →</a></div> -->
<!--       </div> -->
    </div>
  </div>

  <!-- ====== STACK: เกมยูริ ====== -->
  <div class="stack-section" id="yuri">
    <div class="stack-header" onclick="toggleStack(this)">
      <div class="stack-header-left">
        <div class="stack-icon">🌸</div>
        <div>
          <div class="stack-header-title">เกมยูริ</div>
          <div class="stack-header-sub">Girls' Love · Yuri · Lesbian Romance</div>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:0.75rem">
        <div class="stack-count">63 เกม</div>
        <div class="stack-chevron">▼</div>
      </div>
    </div>
    <div class="stack-body">
<!--       <div class="stack-body-inner"> -->
<!--         <div class="hscroll-wrap"> -->
<!--           <div class="hscroll-inner"> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌷</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ดอกทิวลิปสีชมพู</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">ยูริ</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎀</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">โบว์สีฟ้าของเธอ</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">GL</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌺</div><span class="card-badge badge-rec">แนะนำ</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">สองหัวใจพบกัน</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">โรแมนติก</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">☁️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ก้อนเมฆหัวใจ</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">ชีวิต</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🎪</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">คณะละครสาวๆ</div><div class="card-meta"><span class="card-rating">★ 4.5</span><span class="card-genre">ดราม่า</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🌈</div><span class="card-badge badge-hot">HOT</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">สายรุ้งแห่งความรัก</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">GL</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🏵️</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">มาลัยรัก</div><div class="card-meta"><span class="card-rating">★ 4.4</span><span class="card-genre">โรแมนติก</span></div></div></div> -->
<!--             <div class="game-card"><div class="card-thumb"><div class="card-thumb-art">🍵</div><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ชาเขียวในยามเย็น</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">ชีวิต</span></div></div></div> -->
<!--           </div> -->
<!--         </div> -->
<!--         <div style="margin-top:1rem;text-align:right"><a href="#" class="view-all">ดูทั้งหมด 63 เกม →</a></div> -->
<!--       </div> -->
    </div>
  </div>

  <!-- NEW ARRIVALS SECTION -->
  <div class="section reveal" id="newarrivals">
    <div class="section-header">
      <div class="section-left">
        <div class="section-tag">✨ มาใหม่ล่าสุด</div>
        <h2 class="section-title">อัปเดต<span>ประจำสัปดาห์</span></h2>
      </div>
      <a href="#" class="view-all">ดูทั้งหมด →</a>
    </div>
    <div class="cards-grid">
      <div class="game-card reveal reveal-delay-1"><div class="card-thumb"><div class="card-thumb-art">🦊</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">จิ้งจอกเก้าหาง</div><div class="card-meta"><span class="card-rating">★ 4.8</span><span class="card-genre">แฟนตาซี</span></div></div></div>
      <div class="game-card reveal reveal-delay-2"><div class="card-thumb"><div class="card-thumb-art">🌵</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ความรักในทะเลทราย</div><div class="card-meta"><span class="card-rating">★ 4.6</span><span class="card-genre">โรแมนติก</span></div></div></div>
      <div class="game-card reveal reveal-delay-3"><div class="card-thumb"><div class="card-thumb-art">🎆</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">ดอกไม้ไฟแห่งรัก</div><div class="card-meta"><span class="card-rating">★ 4.7</span><span class="card-genre">ชีวิต</span></div></div></div>
      <div class="game-card reveal reveal-delay-1"><div class="card-thumb"><div class="card-thumb-art">🐉</div><span class="card-badge badge-new">NEW</span><div class="card-overlay"></div></div><div class="card-body"><div class="card-title">อัศวินกับมังกร</div><div class="card-meta"><span class="card-rating">★ 4.9</span><span class="card-genre">แฟนตาซี</span></div></div></div>
    </div>
  </div>

</main>

<footer>
  <div class="footer-inner">
    <div>
      <div class="footer-logo">NovelGame</div>
      <p class="footer-copy" style="margin-top:0.5rem">© 2025 NovelGame · สงวนลิขสิทธิ์</p>
    </div>
    <ul class="footer-links">
      <li><a href="#">เกี่ยวกับเรา</a></li>
      <li><a href="#">ส่งผลงาน</a></li>
      <li><a href="#">นโยบายความเป็นส่วนตัว</a></li>
      <li><a href="#">ติดต่อ</a></li>
    </ul>
  </div>
</footer>

<script>
/* =================== PARTICLES =================== */
const canvas = document.getElementById('particle-canvas');
const ctx = canvas.getContext('2d');
let particles = [];
let W, H;

function resize() {
  W = canvas.width = window.innerWidth;
  H = canvas.height = window.innerHeight;
}
resize();
window.addEventListener('resize', resize);

function getParticleColor() {
  const style = getComputedStyle(document.documentElement);
  return style.getPropertyValue('--particle-color').trim() || '#e8a0d8';
}

function hexToRgb(hex) {
  const r = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex.trim());
  return r ? `${parseInt(r[1],16)},${parseInt(r[2],16)},${parseInt(r[3],16)}` : '232,160,216';
}

function createParticles() {
  particles = [];
  const count = Math.min(60, Math.floor(W * H / 20000));
  for (let i = 0; i < count; i++) {
    particles.push({
      x: Math.random() * W,
      y: Math.random() * H,
      r: Math.random() * 2 + 0.5,
      vx: (Math.random() - 0.5) * 0.3,
      vy: (Math.random() - 0.5) * 0.3 - 0.1,
      a: Math.random(),
      da: (Math.random() * 0.003 + 0.001) * (Math.random() > 0.5 ? 1 : -1),
    });
  }
}
createParticles();

let particleColorRgb = hexToRgb(getParticleColor());

function animateParticles() {
  ctx.clearRect(0, 0, W, H);
  particles.forEach(p => {
    p.x += p.vx;
    p.y += p.vy;
    p.a += p.da;
    if (p.a <= 0 || p.a >= 1) p.da *= -1;
    if (p.x < 0) p.x = W; if (p.x > W) p.x = 0;
    if (p.y < 0) p.y = H; if (p.y > H) p.y = 0;
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
    ctx.fillStyle = `rgba(${particleColorRgb},${p.a * 0.5})`;
    ctx.fill();
  });
  requestAnimationFrame(animateParticles);
}
animateParticles();

/* =================== STACK TOGGLE =================== */
function toggleStack(header) {
  const body = header.nextElementSibling;
  const isOpen = body.classList.contains('open');
  body.classList.toggle('open', !isOpen);
  header.classList.toggle('open', !isOpen);
}

/* =================== GENRE FILTER =================== */
function filterGenre(btn, genre) {
  document.querySelectorAll('.genre-pill').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  // Open relevant stacks
  const map = {
    'romance-f': ['romance-f'],
    'romance-m': ['romance-m'],
    'mystery': ['mystery'],
    'dark': ['dark'],
    'yuri': ['yuri'],
    'all': ['romance-f','romance-m','mystery','dark','yuri'],
    'new': ['romance-f','romance-m','mystery','dark','yuri'],
    'hot': ['romance-f','romance-m','mystery','dark','yuri'],
  };
  const targets = map[genre] || [];
  document.querySelectorAll('.stack-section').forEach(section => {
    const id = section.id;
    const header = section.querySelector('.stack-header');
    const body = section.querySelector('.stack-body');
    if (targets.includes(id)) {
      body.classList.add('open');
      header.classList.add('open');
      section.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });
}

/* =================== NAV SCROLL =================== */
function scrollToSection(e, id) {
  e.preventDefault();
  const section = document.getElementById(id);
  if (!section) return;
  const header = section.querySelector('.stack-header');
  const body = section.querySelector('.stack-body');
  if (body && !body.classList.contains('open')) {
    body.classList.add('open');
    header && header.classList.add('open');
  }
  setTimeout(() => {
    section.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }, 50);
}

/* =================== SCROLL REVEAL =================== */
const reveals = document.querySelectorAll('.reveal');
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
}, { threshold: 0.1 });
reveals.forEach(el => observer.observe(el));
</script>
</body>
</html>