
export const mockAdmins = [
  { id: 'ADM001', name: 'Rahul Sharma', email: 'rahul@visionads.com', company: 'Vision Ads', registeredDate: '2023-10-12', status: 'Active', phone: '+91 98765 43210' },
  { id: 'ADM002', name: 'Priya Patel', email: 'priya@brightmedia.in', company: 'Bright Media', registeredDate: '2023-11-05', status: 'Pending', phone: '+91 98765 43211' },
  { id: 'ADM003', name: 'Amit Verma', email: 'amit@adflow.co', company: 'AdFlow solutions', registeredDate: '2023-09-20', status: 'Suspended', phone: '+91 98765 43212' },
  { id: 'ADM004', name: 'Sneha Gupta', email: 'sneha@urbanreach.com', company: 'Urban Reach', registeredDate: '2023-12-01', status: 'Active', phone: '+91 98765 43213' },
  { id: 'ADM005', name: 'Vikram Singh', email: 'vikram@pioneerads.com', company: 'Pioneer Ads', registeredDate: '2023-08-15', status: 'Rejected', phone: '+91 98765 43214' },
  { id: 'ADM006', name: 'Anjali Desai', email: 'anjali@skyhigh.in', company: 'SkyHigh Media', registeredDate: '2024-01-10', status: 'Pending', phone: '+91 98765 43215' },
  { id: 'ADM007', name: 'Karan Mehra', email: 'karan@primeads.com', company: 'Prime Advertisers', registeredDate: '2023-11-28', status: 'Active', phone: '+91 98765 43216' },
  { id: 'ADM008', name: 'Neha Reddy', email: 'neha@localconnect.in', company: 'Local Connect', registeredDate: '2023-10-05', status: 'Active', phone: '+91 98765 43217' },
  { id: 'ADM009', name: 'Siddharth Jain', email: 'sid@nexusmedia.co', company: 'Nexus Media', registeredDate: '2023-12-15', status: 'Suspended', phone: '+91 98765 43218' },
  { id: 'ADM010', name: 'Meera Kapoor', email: 'meera@elevate.in', company: 'Elevate Marketing', registeredDate: '2024-02-01', status: 'Pending', phone: '+91 98765 43219' },
  { id: 'ADM011', name: 'Arjun Malhotra', email: 'arjun@velocity.com', company: 'Velocity Ads', registeredDate: '2023-07-22', status: 'Active', phone: '+91 98765 43220' },
  { id: 'ADM012', name: 'Ritu Saxena', email: 'ritu@creativeforce.in', company: 'Creative Force', registeredDate: '2023-09-30', status: 'Rejected', phone: '+91 98765 43221' },
  { id: 'ADM013', name: 'Sameer Joshi', email: 'sameer@impactmedia.co', company: 'Impact Media', registeredDate: '2023-11-12', status: 'Active', phone: '+91 98765 43222' },
  { id: 'ADM014', name: 'Pooja Bhatia', email: 'pooja@sparkads.in', company: 'Spark Advertising', registeredDate: '2024-01-25', status: 'Pending', phone: '+91 98765 43223' },
  { id: 'ADM015', name: 'Manish Pandey', email: 'manish@horizon.com', company: 'Horizon Media', registeredDate: '2023-08-05', status: 'Active', phone: '+91 98765 43224' },
  { id: 'ADM016', name: 'Tanvi Shah', email: 'tanvi@lumina.in', company: 'Lumina Digital', registeredDate: '2023-12-20', status: 'Active', phone: '+91 98765 43225' },
  { id: 'ADM017', name: 'Rohan Gupta', email: 'rohan@vortex.co', company: 'Vortex Solutions', registeredDate: '2023-10-18', status: 'Suspended', phone: '+91 98765 43226' },
  { id: 'ADM018', name: 'Ishani Roy', email: 'ishani@zenith.in', company: 'Zenith Ads', registeredDate: '2024-02-15', status: 'Pending', phone: '+91 98765 43227' },
  { id: 'ADM019', name: 'Deepak Kumar', email: 'deepak@apex.com', company: 'Apex Marketing', registeredDate: '2023-09-05', status: 'Active', phone: '+91 98765 43228' },
  { id: 'ADM020', name: 'Shweta Mishra', email: 'shweta@glance.in', company: 'Glance Media', registeredDate: '2023-11-30', status: 'Active', phone: '+91 98765 43229' },
];

export const mockPublishers = [
  { id: 'PUB001', name: 'City Mall Display', adminId: 'ADM001', adminName: 'Rahul Sharma', location: 'Mumbai', adsPosted: 12, impressions: 45000, clicks: 1200, engagement: 2.6, status: 'Active', email: 'contact@citymall.com', phone: '+91 88888 77777', joinDate: '2023-11-01' },
  { id: 'PUB002', name: 'Metro Station Screens', adminId: 'ADM001', adminName: 'Rahul Sharma', location: 'Delhi', adsPosted: 8, impressions: 120000, clicks: 3500, engagement: 2.9, status: 'Active', email: 'metro@display.in', phone: '+91 88888 77778', joinDate: '2023-11-15' },
  { id: 'PUB003', name: 'Cafe Coffee Day - CP', adminId: 'ADM004', adminName: 'Sneha Gupta', location: 'Delhi', adsPosted: 5, impressions: 15000, clicks: 450, engagement: 3.0, status: 'Inactive', email: 'ccd.cp@cafe.com', phone: '+91 88888 77779', joinDate: '2023-12-05' },
  { id: 'PUB004', name: 'PVR Cinemas Juhu', adminId: 'ADM007', adminName: 'Karan Mehra', location: 'Mumbai', adsPosted: 15, impressions: 85000, clicks: 2100, engagement: 2.4, status: 'Active', email: 'pvr.juhu@pvr.in', phone: '+91 88888 77780', joinDate: '2023-12-10' },
  { id: 'PUB005', name: 'Apollo Hospital Lobby', adminId: 'ADM008', adminName: 'Neha Reddy', location: 'Bangalore', adsPosted: 4, impressions: 25000, clicks: 300, engagement: 1.2, status: 'Active', email: 'apollo.blr@hospital.in', phone: '+91 88888 77781', joinDate: '2023-10-20' },
  { id: 'PUB006', name: 'IT Park Food Court', adminId: 'ADM011', adminName: 'Arjun Malhotra', location: 'Pune', adsPosted: 22, impressions: 150000, clicks: 6000, engagement: 4.0, status: 'Active', email: 'foodcourt@itpark.com', phone: '+91 88888 77782', joinDate: '2023-08-01' },
  { id: 'PUB007', name: 'DLF Cyber Hub Screen', adminId: 'ADM013', adminName: 'Sameer Joshi', location: 'Gurgaon', adsPosted: 10, impressions: 95000, clicks: 2800, engagement: 2.9, status: 'Suspended', email: 'dlf.screen@dlf.in', phone: '+91 88888 77783', joinDate: '2023-11-20' },
  { id: 'PUB008', name: 'Airport T3 Arrival', adminId: 'ADM015', adminName: 'Manish Pandey', location: 'Delhi', adsPosted: 6, impressions: 300000, clicks: 9000, engagement: 3.0, status: 'Active', email: 't3@airport.in', phone: '+91 88888 77784', joinDate: '2023-09-01' },
  { id: 'PUB009', name: 'Phoenix Marketcity', adminId: 'ADM016', adminName: 'Tanvi Shah', location: 'Chennai', adsPosted: 18, impressions: 110000, clicks: 3800, engagement: 3.4, status: 'Active', email: 'phoenix@mall.in', phone: '+91 88888 77785', joinDate: '2024-01-05' },
  { id: 'PUB010', name: 'Goa Beach Resort', adminId: 'ADM019', adminName: 'Deepak Kumar', location: 'Goa', adsPosted: 3, impressions: 12000, clicks: 600, engagement: 5.0, status: 'Active', email: 'goa@resort.com', phone: '+91 88888 77786', joinDate: '2023-10-10' },
  { id: 'PUB011', name: 'Luxury Gym Chain', adminId: 'ADM001', adminName: 'Rahul Sharma', location: 'Mumbai', adsPosted: 12, impressions: 30000, clicks: 1500, engagement: 5.0, status: 'Active', email: 'gym@chain.in', phone: '+91 88888 77787', joinDate: '2023-10-15' },
  { id: 'PUB012', name: 'High Street Retails', adminId: 'ADM004', adminName: 'Sneha Gupta', location: 'Delhi', adsPosted: 7, impressions: 45000, clicks: 1200, engagement: 2.6, status: 'Active', email: 'highstreet@retail.in', phone: '+91 88888 77788', joinDate: '2024-01-15' },
  { id: 'PUB013', name: 'Central Library', adminId: 'ADM007', adminName: 'Karan Mehra', location: 'Hyderabad', adsPosted: 2, impressions: 8000, clicks: 100, engagement: 1.2, status: 'Inactive', email: 'library@city.in', phone: '+91 88888 77789', joinDate: '2023-12-15' },
  { id: 'PUB014', name: 'Railway Station Platform 1', adminId: 'ADM008', adminName: 'Neha Reddy', location: 'Bangalore', adsPosted: 10, impressions: 250000, clicks: 7500, engagement: 3.0, status: 'Active', email: 'railway@display.in', phone: '+91 88888 77790', joinDate: '2023-11-25' },
  { id: 'PUB015', name: 'Bus Stand Digital Wall', adminId: 'ADM011', adminName: 'Arjun Malhotra', location: 'Pune', adsPosted: 5, impressions: 60000, clicks: 1800, engagement: 3.0, status: 'Active', email: 'busstand@digital.in', phone: '+91 88888 77791', joinDate: '2023-09-10' },
  { id: 'PUB016', name: 'Zudio Store Entrance', adminId: 'ADM013', adminName: 'Sameer Joshi', location: 'Ahmedabad', adsPosted: 8, impressions: 40000, clicks: 1600, engagement: 4.0, status: 'Active', email: 'zudio@retail.com', phone: '+91 88888 77792', joinDate: '2024-02-01' },
  { id: 'PUB017', name: 'Apartment Lift Panels', adminId: 'ADM015', adminName: 'Manish Pandey', location: 'Noida', adsPosted: 30, impressions: 180000, clicks: 5400, engagement: 3.0, status: 'Active', email: 'lift@panels.com', phone: '+91 88888 77793', joinDate: '2023-08-10' },
  { id: 'PUB018', name: 'Tech Park Entrance', adminId: 'ADM016', adminName: 'Tanvi Shah', location: 'Bangalore', adsPosted: 15, impressions: 220000, clicks: 8800, engagement: 4.0, status: 'Active', email: 'techpark@entry.in', phone: '+91 88888 77794', joinDate: '2023-12-25' },
  { id: 'PUB019', name: 'Community Center', adminId: 'ADM020', adminName: 'Shweta Mishra', location: 'Kolkata', adsPosted: 4, impressions: 20000, clicks: 400, engagement: 2.0, status: 'Suspended', email: 'community@center.in', phone: '+91 88888 77795', joinDate: '2024-01-20' },
  { id: 'PUB020', name: 'HyperCity Lobby', adminId: 'ADM001', adminName: 'Rahul Sharma', location: 'Mumbai', adsPosted: 20, impressions: 140000, clicks: 4200, engagement: 3.0, status: 'Active', email: 'hypercity@mall.in', phone: '+91 88888 77796', joinDate: '2023-11-20' },
  { id: 'PUB021', name: 'Luxury Spa & Salon', adminId: 'ADM004', adminName: 'Sneha Gupta', location: 'Delhi', adsPosted: 6, impressions: 18000, clicks: 900, engagement: 5.0, status: 'Active', email: 'spa@salon.in', phone: '+91 88888 77797', joinDate: '2024-02-10' },
  { id: 'PUB022', name: 'Convention Center', adminId: 'ADM007', adminName: 'Karan Mehra', location: 'Jaipur', adsPosted: 3, impressions: 35000, clicks: 1050, engagement: 3.0, status: 'Active', email: 'convention@city.in', phone: '+91 88888 77798', joinDate: '2023-12-01' },
  { id: 'PUB023', name: 'University Cafeteria', adminId: 'ADM011', adminName: 'Arjun Malhotra', location: 'Chandigarh', adsPosted: 9, impressions: 50000, clicks: 2500, engagement: 5.0, status: 'Active', email: 'uni@cafe.in', phone: '+91 88888 77799', joinDate: '2023-08-20' },
  { id: 'PUB024', name: 'Sports Stadium VIP', adminId: 'ADM015', adminName: 'Manish Pandey', location: 'Mumbai', adsPosted: 5, impressions: 100000, clicks: 5000, engagement: 5.0, status: 'Active', email: 'stadium@vip.in', phone: '+91 88888 77800', joinDate: '2023-09-15' },
  { id: 'PUB025', name: 'Boutique Hotel Lobby', adminId: 'ADM019', adminName: 'Deepak Kumar', location: 'Udaipur', adsPosted: 4, impressions: 22000, clicks: 1100, engagement: 5.0, status: 'Active', email: 'boutique@hotel.in', phone: '+91 88888 77801', joinDate: '2023-10-25' },
];

export const mockAds = [
  { id: 'AD001', title: 'Summer Sale Blast', type: 'Banner', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB001', publisherName: 'City Mall Display', createdDate: '2024-03-01', status: 'Active', impressions: 12500, clicks: 450, ctr: 3.6, startDate: '2024-03-01', endDate: '2024-04-01', location: 'Mumbai', radius: '5km', image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80' },
  { id: 'AD002', title: 'New Car Launch', type: 'Video', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB002', publisherName: 'Metro Station Screens', createdDate: '2024-03-05', status: 'Active', impressions: 45000, clicks: 1800, ctr: 4.0, startDate: '2024-03-05', endDate: '2024-05-05', location: 'Delhi', radius: '10km', image: 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80' },
  { id: 'AD003', title: 'Pizza Buy 1 Get 1', type: 'Thumbnail', adminId: 'ADM004', adminName: 'Sneha Gupta', publisherId: 'PUB003', publisherName: 'Cafe Coffee Day - CP', createdDate: '2024-02-15', status: 'Expired', impressions: 8500, clicks: 250, ctr: 2.9, startDate: '2024-02-15', endDate: '2024-03-15', location: 'Delhi', radius: '1km', image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80' },
  { id: 'AD004', title: 'Luxury watch Promo', type: 'Banner', adminId: 'ADM007', adminName: 'Karan Mehra', publisherId: 'PUB004', publisherName: 'PVR Cinemas Juhu', createdDate: '2024-03-10', status: 'Active', impressions: 22000, clicks: 660, ctr: 3.0, startDate: '2024-03-10', endDate: '2024-04-10', location: 'Mumbai', radius: '2km', image: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=800&q=80' },
  { id: 'AD005', title: 'Health Checkup Pack', type: 'Video', adminId: 'ADM008', adminName: 'Neha Reddy', publisherId: 'PUB005', publisherName: 'Apollo Hospital Lobby', createdDate: '2024-03-12', status: 'Active', impressions: 15000, clicks: 300, ctr: 2.0, startDate: '2024-03-12', endDate: '2025-03-12', location: 'Bangalore', radius: '1km', image: 'https://images.unsplash.com/photo-1505751172107-109009949671?w=800&q=80' },
  { id: 'AD006', title: 'App Install Campaign', type: 'Thumbnail', adminId: 'ADM011', adminName: 'Arjun Malhotra', publisherId: 'PUB006', publisherName: 'IT Park Food Court', createdDate: '2024-01-20', status: 'Suspended', impressions: 50000, clicks: 2500, ctr: 5.0, startDate: '2024-01-20', endDate: '2024-06-20', location: 'Pune', radius: '5km', image: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80' },
  { id: 'AD007', title: 'Realty Project Launch', type: 'Banner', adminId: 'ADM013', adminName: 'Sameer Joshi', publisherId: 'PUB007', publisherName: 'DLF Cyber Hub Screen', createdDate: '2024-03-15', status: 'Draft', impressions: 0, clicks: 0, ctr: 0, startDate: '2024-04-01', endDate: '2024-06-01', location: 'Gurgaon', radius: '10km', image: 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800&q=80' },
  { id: 'AD008', title: 'Airline Early Bird', type: 'Video', adminId: 'ADM015', adminName: 'Manish Pandey', publisherId: 'PUB008', publisherName: 'Airport T3 Arrival', createdDate: '2024-02-01', status: 'Active', impressions: 120000, clicks: 4800, ctr: 4.0, startDate: '2024-02-01', endDate: '2024-05-01', location: 'Delhi', radius: '10km', image: 'https://images.unsplash.com/photo-1436491865332-7a61a109c0f3?w=800&q=80' },
  { id: 'AD009', title: 'Fashion Week Tickets', type: 'Thumbnail', adminId: 'ADM016', adminName: 'Tanvi Shah', publisherId: 'PUB009', publisherName: 'Phoenix Marketcity', createdDate: '2024-03-18', status: 'Active', impressions: 35000, clicks: 1400, ctr: 4.0, startDate: '2024-03-18', endDate: '2024-04-18', location: 'Chennai', radius: '5km', image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80' },
  { id: 'AD010', title: 'Watersports Pack', type: 'Banner', adminId: 'ADM019', adminName: 'Deepak Kumar', publisherId: 'PUB010', publisherName: 'Goa Beach Resort', createdDate: '2024-03-20', status: 'Active', impressions: 9000, clicks: 450, ctr: 5.0, startDate: '2024-03-20', endDate: '2024-05-20', location: 'Goa', radius: '5km', image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&q=80' },
  { id: 'AD011', title: 'Gym Membership Sale', type: 'Banner', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB011', publisherName: 'Luxury Gym Chain', createdDate: '2024-03-05', status: 'Active', impressions: 18000, clicks: 900, ctr: 5.0, startDate: '2024-03-05', endDate: '2024-04-05', location: 'Mumbai', radius: '5km', image: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80' },
  { id: 'AD012', title: 'Tech Gadget Launch', type: 'Video', adminId: 'ADM004', adminName: 'Sneha Gupta', publisherId: 'PUB012', publisherName: 'High Street Retails', createdDate: '2024-01-10', status: 'Expired', impressions: 65000, clicks: 1950, ctr: 3.0, startDate: '2024-01-10', endDate: '2024-02-10', location: 'Delhi', radius: '2km', image: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&q=80' },
  { id: 'AD013', title: 'Software Discount', type: 'Thumbnail', adminId: 'ADM011', adminName: 'Arjun Malhotra', publisherId: 'PUB006', publisherName: 'IT Park Food Court', createdDate: '2024-03-10', status: 'Active', impressions: 22000, clicks: 1100, ctr: 5.0, startDate: '2024-03-10', endDate: '2024-06-10', location: 'Pune', radius: '5km', image: 'https://images.unsplash.com/photo-1551288049-bbbda536339a?w=800&q=80' },
  { id: 'AD014', title: 'Organic Grocery Promo', type: 'Banner', adminId: 'ADM015', adminName: 'Manish Pandey', publisherId: 'PUB017', publisherName: 'Apartment Lift Panels', createdDate: '2024-02-20', status: 'Active', impressions: 45000, clicks: 1350, ctr: 3.0, startDate: '2024-02-20', endDate: '2024-05-20', location: 'Noida', radius: '1km', image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80' },
  { id: 'AD015', title: 'Cloud Services Ad', type: 'Video', adminId: 'ADM016', adminName: 'Tanvi Shah', publisherId: 'PUB018', publisherName: 'Tech Park Entrance', createdDate: '2024-03-01', status: 'Active', impressions: 85000, clicks: 3400, ctr: 4.0, startDate: '2024-03-01', endDate: '2024-06-01', location: 'Bangalore', radius: '5km', image: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80' },
  { id: 'AD016', title: 'Music Fest Early Access', type: 'Thumbnail', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB020', publisherName: 'HyperCity Lobby', createdDate: '2024-03-15', status: 'Draft', impressions: 0, clicks: 0, ctr: 0, startDate: '2024-04-15', endDate: '2024-05-15', location: 'Mumbai', radius: '5km', image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&q=80' },
  { id: 'AD017', title: 'Spa & Wellness Expo', type: 'Banner', adminId: 'ADM004', adminName: 'Sneha Gupta', publisherId: 'PUB021', publisherName: 'Luxury Spa & Salon', createdDate: '2024-03-22', status: 'Active', impressions: 5000, clicks: 250, ctr: 5.0, startDate: '2024-03-22', endDate: '2024-05-22', location: 'Delhi', radius: '2km', image: 'https://images.unsplash.com/photo-1544161515-4508f5ad4c14?w=800&q=80' },
  { id: 'AD018', title: 'Heritage Tour Promo', type: 'Video', adminId: 'ADM007', adminName: 'Karan Mehra', publisherId: 'PUB022', publisherName: 'Convention Center', createdDate: '2024-03-01', status: 'Active', impressions: 22000, clicks: 660, ctr: 3.0, startDate: '2024-03-01', endDate: '2024-06-01', location: 'Jaipur', radius: '5km', image: 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800&q=80' },
  { id: 'AD019', title: 'E-Learning Course Sale', type: 'Thumbnail', adminId: 'ADM011', adminName: 'Arjun Malhotra', publisherId: 'PUB023', publisherName: 'University Cafeteria', createdDate: '2024-03-10', status: 'Active', impressions: 18000, clicks: 900, ctr: 5.0, startDate: '2024-03-10', endDate: '2024-05-10', location: 'Chandigarh', radius: '5km', image: 'https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=800&q=80' },
  { id: 'AD020', title: 'IPL Final Tickets', type: 'Banner', adminId: 'ADM015', adminName: 'Manish Pandey', publisherId: 'PUB024', publisherName: 'Sports Stadium VIP', createdDate: '2024-03-25', status: 'Active', impressions: 55000, clicks: 2750, ctr: 5.0, startDate: '2024-03-25', endDate: '2025-03-25', location: 'Mumbai', radius: '10km', image: 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?w=800&q=80' },
  { id: 'AD021', title: 'Wedding Photography', type: 'Video', adminId: 'ADM019', adminName: 'Deepak Kumar', publisherId: 'PUB025', publisherName: 'Boutique Hotel Lobby', createdDate: '2024-03-01', status: 'Active', impressions: 12000, clicks: 600, ctr: 5.0, startDate: '2024-03-01', endDate: '2024-06-01', location: 'Udaipur', radius: '5km', image: 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&q=80' },
  { id: 'AD022', title: 'Juice Bar Grand Opening', type: 'Thumbnail', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB001', publisherName: 'City Mall Display', createdDate: '2024-02-15', status: 'Expired', impressions: 15000, clicks: 450, ctr: 3.0, startDate: '2024-02-15', endDate: '2024-03-15', location: 'Mumbai', radius: '2km', image: 'https://images.unsplash.com/photo-1613478223719-2ab8026aba7d?w=800&q=80' },
  { id: 'AD023', title: 'Real Estate Summit', type: 'Banner', adminId: 'ADM013', adminName: 'Sameer Joshi', publisherId: 'PUB007', publisherName: 'DLF Cyber Hub Screen', createdDate: '2024-01-05', status: 'Suspended', impressions: 32000, clicks: 960, ctr: 3.0, startDate: '2024-01-05', endDate: '2024-03-05', location: 'Gurgaon', radius: '5km', image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800&q=80' },
  { id: 'AD024', title: 'Local Bakery - Morning Deals', type: 'Thumbnail', adminId: 'ADM020', adminName: 'Shweta Mishra', publisherId: 'PUB019', publisherName: 'Community Center', createdDate: '2024-03-10', status: 'Active', impressions: 8000, clicks: 160, ctr: 2.0, startDate: '2024-03-10', endDate: '2024-04-10', location: 'Kolkata', radius: '2km', image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80' },
  { id: 'AD025', title: 'Yoga Retreat Workshop', type: 'Video', adminId: 'ADM019', adminName: 'Deepak Kumar', publisherId: 'PUB010', publisherName: 'Goa Beach Resort', createdDate: '2024-03-05', status: 'Active', impressions: 11000, clicks: 550, ctr: 5.0, startDate: '2024-03-05', endDate: '2024-05-05', location: 'Goa', radius: '5km', image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=80' },
  { id: 'AD026', title: 'Furniture Clearance', type: 'Banner', adminId: 'ADM016', adminName: 'Tanvi Shah', publisherId: 'PUB009', publisherName: 'Phoenix Marketcity', createdDate: '2024-02-01', status: 'Expired', impressions: 48000, clicks: 1440, ctr: 3.0, startDate: '2024-02-01', endDate: '2024-03-01', location: 'Chennai', radius: '10km', image: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800&q=80' },
  { id: 'AD027', title: 'Mobile Repair Service', type: 'Thumbnail', adminId: 'ADM013', adminName: 'Sameer Joshi', publisherId: 'PUB016', publisherName: 'Zudio Store Entrance', createdDate: '2024-03-12', status: 'Active', impressions: 16000, clicks: 640, ctr: 4.0, startDate: '2024-03-12', endDate: '2024-06-12', location: 'Ahmedabad', radius: '5km', image: 'https://images.unsplash.com/photo-1512428559087-560fa5ceab42?w=800&q=80' },
  { id: 'AD028', title: 'Coffee Shop - Work from Here', type: 'Banner', adminId: 'ADM004', adminName: 'Sneha Gupta', publisherId: 'PUB003', publisherName: 'Cafe Coffee Day - CP', createdDate: '2024-03-20', status: 'Draft', impressions: 0, clicks: 0, ctr: 0, startDate: '2024-04-01', endDate: '2024-05-01', location: 'Delhi', radius: '1km', image: 'https://images.unsplash.com/photo-1501339817302-ee4b9435fa68?w=800&q=80' },
  { id: 'AD029', title: 'Public Service - Clean City', type: 'Video', adminId: 'ADM008', adminName: 'Neha Reddy', publisherId: 'PUB014', publisherName: 'Railway Station Platform 1', createdDate: '2024-03-01', status: 'Active', impressions: 180000, clicks: 3600, ctr: 2.0, startDate: '2024-03-01', endDate: '2024-09-01', location: 'Bangalore', radius: '10km', image: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&q=80' },
  { id: 'AD030', title: 'New Restaurant Open', type: 'Banner', adminId: 'ADM011', adminName: 'Arjun Malhotra', publisherId: 'PUB015', publisherName: 'Bus Stand Digital Wall', createdDate: '2024-03-15', status: 'Active', impressions: 22000, clicks: 660, ctr: 3.0, startDate: '2024-03-15', endDate: '2024-05-15', location: 'Pune', radius: '5km', image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80' },
  { id: 'AD031', title: 'Dental Clinic - Free Checkup', type: 'Thumbnail', adminId: 'ADM015', adminName: 'Manish Pandey', publisherId: 'PUB017', publisherName: 'Apartment Lift Panels', createdDate: '2024-03-01', status: 'Active', impressions: 12000, clicks: 240, ctr: 2.0, startDate: '2024-03-01', endDate: '2024-04-01', location: 'Noida', radius: '1km', image: 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?w=800&q=80' },
  { id: 'AD032', title: 'Jewelry Collection Launch', type: 'Banner', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB004', publisherName: 'PVR Cinemas Juhu', createdDate: '2024-02-10', status: 'Expired', impressions: 35000, clicks: 1050, ctr: 3.0, startDate: '2024-02-10', endDate: '2024-03-10', location: 'Mumbai', radius: '5km', image: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&q=80' },
  { id: 'AD033', title: 'Stock Trading Masterclass', type: 'Video', adminId: 'ADM016', adminName: 'Tanvi Shah', publisherId: 'PUB018', publisherName: 'Tech Park Entrance', createdDate: '2024-03-10', status: 'Active', impressions: 42000, clicks: 1680, ctr: 4.0, startDate: '2024-03-10', endDate: '2024-06-10', location: 'Bangalore', radius: '5km', image: 'https://images.unsplash.com/photo-1611974714851-eb6077374236?w=800&q=80' },
  { id: 'AD034', title: 'Local Festival - Cultural Night', type: 'Banner', adminId: 'ADM020', adminName: 'Shweta Mishra', publisherId: 'PUB019', publisherName: 'Community Center', createdDate: '2024-03-01', status: 'Suspended', impressions: 5000, clicks: 100, ctr: 2.0, startDate: '2024-03-01', endDate: '2024-03-31', location: 'Kolkata', radius: '5km', image: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80' },
  { id: 'AD035', title: 'Pet Grooming Service', type: 'Thumbnail', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB001', publisherName: 'City Mall Display', createdDate: '2024-03-25', status: 'Active', impressions: 1200, clicks: 36, ctr: 3.0, startDate: '2024-03-25', endDate: '2024-04-25', location: 'Mumbai', radius: '2km', image: 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=800&q=80' },
  { id: 'AD036', title: 'Luxury Resort - Early Summer', type: 'Video', adminId: 'ADM019', adminName: 'Deepak Kumar', publisherId: 'PUB025', publisherName: 'Boutique Hotel Lobby', createdDate: '2024-03-20', status: 'Active', impressions: 4500, clicks: 225, ctr: 5.0, startDate: '2024-03-20', endDate: '2024-06-20', location: 'Udaipur', radius: '10km', image: 'https://images.unsplash.com/photo-1540541338287-41700207dee6?w=800&q=80' },
  { id: 'AD037', title: 'Auto Expo 2024', type: 'Banner', adminId: 'ADM013', adminName: 'Sameer Joshi', publisherId: 'PUB007', publisherName: 'DLF Cyber Hub Screen', createdDate: '2024-01-15', status: 'Expired', impressions: 85000, clicks: 2550, ctr: 3.0, startDate: '2024-01-15', endDate: '2024-02-15', location: 'Gurgaon', radius: '10km', image: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=800&q=80' },
  { id: 'AD038', title: 'Fashion Clearance - 70% Off', type: 'Thumbnail', adminId: 'ADM016', adminName: 'Tanvi Shah', publisherId: 'PUB009', publisherName: 'Phoenix Marketcity', createdDate: '2024-03-28', status: 'Active', impressions: 15000, clicks: 600, ctr: 4.0, startDate: '2024-03-28', endDate: '2024-04-28', location: 'Chennai', radius: '5km', image: 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800&q=80' },
  { id: 'AD039', title: 'Home Insurance Plan', type: 'Video', adminId: 'ADM015', adminName: 'Manish Pandey', publisherId: 'PUB017', publisherName: 'Apartment Lift Panels', createdDate: '2024-03-15', status: 'Active', impressions: 28000, clicks: 840, ctr: 3.0, startDate: '2024-03-15', endDate: '2025-03-15', location: 'Noida', radius: '1km', image: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&q=80' },
  { id: 'AD040', title: 'Street Food Festival', type: 'Banner', adminId: 'ADM001', adminName: 'Rahul Sharma', publisherId: 'PUB020', publisherName: 'HyperCity Lobby', createdDate: '2024-03-22', status: 'Active', impressions: 12000, clicks: 360, ctr: 3.0, startDate: '2024-03-22', endDate: '2024-04-22', location: 'Mumbai', radius: '5km', image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80' },

];

export const adPerformanceData = {
  kpis: [
    { title: 'Total Impressions', value: '1,245,800', change: 12.5 },
    { title: 'Total Clicks', value: '38,940', change: 18.2 },
    { title: 'Avg CTR', value: '3.12%', change: 4.1 },
  ],
  topAds: [
    { name: 'Summer Sale Blast', impressions: 45000, clicks: 1800 },
    { name: 'New Car Launch', impressions: 42000, clicks: 2100 },
    { name: 'Airline Early Bird', impressions: 38000, clicks: 1520 },
    { name: 'Cloud Services Ad', impressions: 35000, clicks: 1400 },
    { name: 'App Install campaign', impressions: 32000, clicks: 1600 },
    { name: 'Fashion Week Tickets', impressions: 28000, clicks: 1120 },
    { name: 'IPL Final Tickets', impressions: 25000, clicks: 1250 },
    { name: 'Luxury watch Promo', impressions: 22000, clicks: 660 },
    { name: 'Health Checkup Pack', impressions: 18000, clicks: 450 },
    { name: 'Gym Membership Sale', impressions: 15000, clicks: 750 },
  ],
  byType: [
    { name: 'Banner', value: 512 },
    { name: 'Video', value: 198 },
    { name: 'Thumbnail', value: 88 },
  ],
  topLocations: [
    { name: 'Mumbai', value: 450000 },
    { name: 'Delhi', value: 380000 },
    { name: 'Bangalore', value: 310000 },
    { name: 'Pune', value: 220000 },
    { name: 'Chennai', value: 180000 },
  ]
};

export const geoAnalyticsData = {
  table: [
    { city: 'Mumbai', impressions: 450000, clicks: 13500, ctr: '3.0%', status: 'Active' },
    { city: 'Delhi', impressions: 380000, clicks: 11400, ctr: '3.0%', status: 'Active' },
    { city: 'Bangalore', impressions: 310000, clicks: 9300, ctr: '3.0%', status: 'Active' },
    { city: 'Pune', impressions: 220000, clicks: 8800, ctr: '4.0%', status: 'Active' },
    { city: 'Chennai', impressions: 180000, clicks: 7200, ctr: '4.0%', status: 'Active' },
    { city: 'Hyderabad', impressions: 150000, clicks: 4500, ctr: '3.0%', status: 'Active' },
    { city: 'Kolkata', impressions: 120000, clicks: 2400, ctr: '2.0%', status: 'Active' },
  ],
  engagementByRadius: [
    { radius: '1km', value: 4.2 },
    { radius: '2km', value: 3.5 },
    { radius: '5km', value: 2.8 },
    { radius: '10km', value: 2.1 },
  ],
  topLocation: { city: 'Mumbai', metric: '4.5L Impressions' }
};

export const adminAnalyticsData = {
  table: [
    { name: 'Rahul Sharma', revenue: 450000, ads: 124, ctr: 3.2, rank: 1 },
    { name: 'Sneha Gupta', revenue: 380000, ads: 98, ctr: 3.1, rank: 2 },
    { name: 'Karan Mehra', revenue: 310000, ads: 85, ctr: 2.9, rank: 3 },
    { name: 'Arjun Malhotra', revenue: 290000, ads: 76, ctr: 3.4, rank: 4 },
    { name: 'Manish Pandey', revenue: 250000, ads: 68, ctr: 3.0, rank: 5 },
  ],
  revenuePerAdmin: [
    { name: 'Rahul S.', revenue: 450000 },
    { name: 'Sneha G.', revenue: 380000 },
    { name: 'Karan M.', revenue: 310000 },
    { name: 'Arjun M.', revenue: 290000 },
    { name: 'Manish P.', revenue: 250000 },
  ]
};

export const publisherAnalyticsData = {
  table: [
    { name: 'City Mall Display', ads: 12, impressions: 45000, engagement: 2.6, status: 'Active' },
    { name: 'Metro Station Screens', ads: 8, impressions: 120000, engagement: 2.9, status: 'Active' },
    { name: 'IT Park Food Court', ads: 22, impressions: 150000, engagement: 4.0, status: 'Active' },
    { name: 'Airport T3 Arrival', ads: 6, impressions: 300000, engagement: 3.0, status: 'Active' },
    { name: 'Phoenix Marketcity', ads: 18, impressions: 110000, engagement: 3.4, status: 'Active' },
  ]
};

export const timeAnalyticsData = {
  hourWise: [
    { hour: '00', engagement: 120 }, { hour: '01', engagement: 80 }, { hour: '02', engagement: 40 },
    { hour: '03', engagement: 20 }, { hour: '04', engagement: 15 }, { hour: '05', engagement: 30 },
    { hour: '06', engagement: 150 }, { hour: '07', engagement: 450 }, { hour: '08', engagement: 800 },
    { hour: '09', engagement: 1200 }, { hour: '10', engagement: 1500 }, { hour: '11', engagement: 1800 },
    { hour: '12', engagement: 2200 }, { hour: '13', engagement: 2500 }, { hour: '14', engagement: 2100 },
    { hour: '15', engagement: 1900 }, { hour: '16', engagement: 2300 }, { hour: '17', engagement: 2800 },
    { hour: '18', engagement: 3500 }, { hour: '19', engagement: 4200 }, { hour: '20', engagement: 3800 },
    { hour: '21', engagement: 2800 }, { hour: '22', engagement: 1800 }, { hour: '23', engagement: 800 },
  ],
  dailyTrend: [
    { date: 'Mon', impressions: 12000, clicks: 480 },
    { date: 'Tue', impressions: 15000, clicks: 600 },
    { date: 'Wed', impressions: 14000, clicks: 560 },
    { date: 'Thu', impressions: 18000, clicks: 720 },
    { date: 'Fri', impressions: 22000, clicks: 880 },
    { date: 'Sat', impressions: 28000, clicks: 1120 },
    { date: 'Sun', impressions: 25000, clicks: 1000 },
  ],
  durationVsCtr: [
    { duration: '1 Week', ctr: 2.8 },
    { duration: '2 Weeks', ctr: 3.2 },
    { duration: '1 Month', ctr: 3.5 },
    { duration: '3 Months', ctr: 3.1 },
    { duration: '6 Months', ctr: 2.6 },
  ]
};

export const mockTickets = [
  {
    id: 'TKT-1001',
    subject: 'Unable to upload high-res banners',
    status: 'Open',
    priority: 'High',
    category: 'Technical',
    userName: 'Rahul Sharma',
    userType: 'Admin',
    lastUpdated: '2 hours ago',
    createdDate: '2024-04-14',
    messages: [
      { id: 'm1', sender: 'Rahul Sharma', text: 'Hey, I am trying to upload a 4K resolution banner for the Summer Sale campaign but it keeps giving a timeout error.', timestamp: '10:30 AM', isMe: false },
      { id: 'm2', sender: 'System', text: 'Ticket created and assigned to Technical Support.', timestamp: '10:31 AM', isMe: true }
    ]
  },
  {
    id: 'TKT-1002',
    subject: 'Payout delayed for March cycle',
    status: 'In Progress',
    priority: 'Urgent',
    category: 'Payment',
    userName: 'Metro Station Screens',
    userType: 'Publisher',
    lastUpdated: '15 mins ago',
    createdDate: '2024-04-13',
    messages: [
      { id: 'm1', sender: 'Metro Station Screens', text: 'Our payout for the March advertisement cycle is still pending. Usually it is cleared by 5th. Please check.', timestamp: 'Yesterday', isMe: false },
      { id: 'm2', sender: 'Super Admin', text: 'Checking with the finance department. Will update shortly.', timestamp: '9:00 AM', isMe: true },
      { id: 'm3', sender: 'Metro Station Screens', text: 'Thank you, waiting for the update.', timestamp: '9:15 AM', isMe: false }
    ]
  },
  {
    id: 'TKT-1003',
    subject: 'Incorrect analytics reporting',
    status: 'Resolved',
    priority: 'Medium',
    category: 'Bug',
    userName: 'Karan Mehra',
    userType: 'Admin',
    lastUpdated: '1 day ago',
    createdDate: '2024-04-12',
    messages: [
      { id: 'm1', sender: 'Karan Mehra', text: 'The CTR for PVR Juhu campaign shows 0% even with 5000 clicks. This seems wrong.', timestamp: '2 days ago', isMe: false },
      { id: 'm2', sender: 'Super Admin', text: 'This was a sync error with the tracker service. It has been resolved and the data should be correct now.', timestamp: '1 day ago', isMe: true }
    ]
  },
  {
    id: 'TKT-1004',
    subject: 'Request for New Ad Format',
    status: 'Closed',
    priority: 'Low',
    category: 'Feedback',
    userName: 'Sneha Gupta',
    userType: 'Admin',
    lastUpdated: '1 week ago',
    createdDate: '2024-04-05',
    messages: [
      { id: 'm1', sender: 'Sneha Gupta', text: 'Can we add support for carousel ads in the next update?', timestamp: '1 week ago', isMe: false },
      { id: 'm2', sender: 'Super Admin', text: 'Thank you for the feedback. We will consider this for the Q3 roadmap.', timestamp: '1 week ago', isMe: true }
    ]
  }
];
