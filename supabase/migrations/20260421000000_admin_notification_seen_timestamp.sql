-- Add columns to track last seen timestamps for admin notifications
-- This enables global notification sync across all admin accounts

ALTER TABLE orders
ADD COLUMN IF NOT EXISTS purchase_pending_seen_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
ADD COLUMN IF NOT EXISTS rental_pending_seen_at TIMESTAMP WITH TIME ZONE DEFAULT NULL;

COMMENT ON COLUMN orders.purchase_pending_seen_at IS 'Timestamp when admin last viewed pending purchases';
COMMENT ON COLUMN orders.rental_pending_seen_at IS 'Timestamp when admin last viewed pending rentals';