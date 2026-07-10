# KELIRI — Super Admin Web Platform | SRS v1.1

**Vinidra Softech | Confidential**

---

# KELIRI

## Geo-Targeted Advertisement Ecosystem

# SOFTWARE REQUIREMENTS SPECIFICATION

## Super Admin Web Platform

**Version:** 1.1
**Date:** 13 April 2026
**Prepared By:** Vinidra Softech
**Classification:** Confidential

---

# 1. Project Overview

This document defines the Software Requirements Specification (SRS) for the KELIRI Super Admin Web Platform — a centralized control interface for the KELIRI Geo-Targeted Advertisement Ecosystem. It is intended for use by the development team, QA, and the client.

## Parameters

| Parameter      | Details                                                    |
| -------------- | ---------------------------------------------------------- |
| Platform       | Web Application (Desktop-first)                            |
| Primary User   | Super Admin (Master) + Sub-Admins                          |
| Purpose        | Monitoring, analytics, revenue tracking, user & ad control |
| Integration    | Publisher App, Admin Panel, End User Web & App             |
| Authentication | Email + Password OR Phone + OTP                            |
| API Standard   | RESTful APIs, JSON, HTTPS                                  |

---

# 2. User Roles & Permission Management

## 2.1 Overview

* **Master Super Admin**

  * Full unrestricted access
  * Can create/manage Sub-Admins

* **Sub Super Admin**

  * Created by Master
  * Assigned module-level permissions

> Sub-Admins cannot create other Sub-Admins.

---

## 2.2 Permission Modules

| Module                   | Access                        |
| ------------------------ | ----------------------------- |
| Dashboard                | View KPIs                     |
| Analytics & Reporting    | View/export analytics         |
| Admin Management         | Approve/reject/suspend admins |
| Publisher Monitoring     | View publisher data           |
| Advertisement Monitoring | Manage ads                    |
| Revenue & Financials     | View/export revenue           |
| Ticketing & Support      | Manage tickets                |
| Sub-Admin Management     | Master only                   |

---

## 2.3 Sub-Admin Management

* Create Sub-Admin
* Edit details/permissions
* Suspend / Deactivate
* Delete Sub-Admin
* View login activity

---

## 2.4 Navigation & Access Control

* Menu is permission-based
* Unauthorized access → **Access Denied**

---

# 3. Authentication Module

## 3.1 Login Methods

### Email & Password

* Login via email + password
* 5 failed attempts → account locked

### Phone & OTP

* OTP valid for 5 minutes
* Resend after 60 seconds

---

## 3.2 Session Management

* JWT validity: 24 hours
* Auto session expiry
* Logout clears session

---

## 3.3 Email Notifications

| Trigger           | Email Sent To    | Content              |
| ----------------- | ---------------- | -------------------- |
| Account locked    | Registered email | Unlock link          |
| Sub-Admin created | Sub-Admin email  | Welcome + setup link |

---

# 4. Dashboard

## 4.1 KPI Cards

| Metric           | Description                |
| ---------------- | -------------------------- |
| Total Revenue    | Daily / Monthly / All-time |
| Total Ads        | Active / Expired / Pending |
| Total Admins     | Active / Pending           |
| Total Publishers | Count                      |
| Ad Clicks Today  | Daily clicks               |
| Active Campaigns | Running campaigns          |
| Total Users      | Total users                |

---

## 4.2 Charts

* To be implemented where necessary

---

# 5. Analytics & Reporting

## 5.1 Global Filters

| Filter     | Options                                |
| ---------- | -------------------------------------- |
| Date Range | Today / 7 / 30 / 90 days               |
| Admin      | Multi-select                           |
| Publisher  | Multi-select                           |
| Ad Type    | Banner / Video / Thumbnail             |
| Location   | Multi-select                           |
| Radius     | 1km / 2km / 5km / 10km                 |
| Ad Status  | Active / Expired / Pending / Suspended |

---

## 5.2 Analytics Sub-Sections

### A. Ad Performance

* Impressions, clicks, CTR
* Performance by type/location

### B. Geo-Based Analytics

* City-based performance
* Radius comparison
* High-performing areas

### C. Admin-Level Analytics

* Revenue per admin
* Performance ranking

### D. Publisher-Level Analytics

* Ads per publisher
* Engagement metrics

### E. Time-Based Analytics

* Hourly/daily trends

---

## 5.3 Export

* CSV / Excel export
* Filters applied to export

---

# 6. User Management

## 6.1 Admin Management

* View admins (Pending / Active / Rejected / Suspended)
* Search & filter
* Approve / Reject / Suspend

### Email Notifications

| Trigger  | Email        |
| -------- | ------------ |
| Approved | Confirmation |
| Rejected | Reason       |

---

## 6.2 Publisher Monitoring

* View publishers
* Read-only for Super Admin

---

## 6.3 Activity Logs

* Full audit trail
* Filters available
* Read-only logs

---

# 7. Advertisement Monitoring

## 7.1 Ad List

* Filter by status, type, admin, location
* Actions: View / Suspend

---

## 7.2 Ad Lifecycle

| State     | Description   |
| --------- | ------------- |
| Draft     | Not published |
| Active    | Live          |
| Expired   | Ended         |
| Suspended | Disabled      |

---

## 7.3 Ad Detail

* Same as app features

---

# 8. Revenue Management

## 8.1 Dashboard

* Total revenue
* Trends (daily/weekly/monthly)
* Charts (admin/type/location)

---

## 8.2 Transactions

* Filtered transaction logs
* Includes ID, amount, status

---

## 8.3 Reports

* Export CSV/Excel
* Admin-wise breakdown

---

# 9. Ticketing & Support

## 9.1 Ticket List

* Filter by status
* Search tickets

---

## 9.2 Ticket Detail

* Chat-style thread
* Status updates

---

## 9.3 Email Notifications

| Trigger    | Action       |
| ---------- | ------------ |
| New Ticket | Alert        |
| Reply      | Notification |
| Resolved   | Confirmation |

---

# 10. Non-Functional Requirements

| Category    | Requirement                   |
| ----------- | ----------------------------- |
| Security    | HTTPS, JWT, role-based access |
| Performance | <5s load, <1s API             |
| Usability   | Desktop-first, responsive     |
| Reliability | Confirmation dialogs          |
| Audit       | All actions logged            |
| Data Export | CSV/Excel                     |
| Email       | Backend email service         |
| OTP         | 30s delivery, 5-min validity  |

---

# 11. Screen Inventory

| ID     | Screen               |
| ------ | -------------------- |
| SA-001 | Login                |
| SA-002 | Dashboard            |
| SA-003 | Sub-Admin Management |
| SA-004 | Ad Performance       |
| SA-005 | Geo Analytics        |
| SA-006 | Admin Analytics      |
| SA-007 | Publisher Analytics  |
| SA-008 | Time Analytics       |
| SA-009 | Admin List           |
| SA-010 | Admin Detail         |
| SA-011 | Publisher List       |
| SA-012 | Publisher Detail     |
| SA-013 | Activity Logs        |
| SA-014 | Ads List             |
| SA-015 | Ads Detail           |
| SA-016 | Revenue Dashboard    |
| SA-017 | Transactions         |
| SA-018 | Ticket List          |
| SA-019 | Ticket Detail        |

---

# 12. Project Timeline

| Milestone    | Date          | Scope                  |
| ------------ | ------------- | ---------------------- |
| Frontend     | 20 April 2026 | UI ready               |
| Full Project | 8 May 2026    | Backend + integrations |
| Testing      | 11 May 2026   | Handover               |

---

## 12.1 Assumptions

* Client feedback within 2 days
* No major scope changes
* Credentials provided by client

---

## 12.2 Post-Handover

* Basic testing included
* Bug fixes under support period