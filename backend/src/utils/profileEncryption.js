import crypto from "crypto";

const ALGORITHM = "aes-256-gcm";
const ENCRYPTION_PREFIX = "enc:v1";

function getEncryptionKey() {
  const secret = process.env.PROFILE_ENCRYPTION_KEY || process.env.JWT_SECRET;
  if (!secret) {
    throw new Error("PROFILE_ENCRYPTION_KEY (or JWT_SECRET fallback) is not configured");
  }

  // Derive a fixed 32-byte key from any non-empty secret string.
  return crypto.createHash("sha256").update(secret, "utf8").digest();
}

function encryptValue(value) {
  if (value === undefined || value === null) {
    return null;
  }

  const key = getEncryptionKey();
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv(ALGORITHM, key, iv);
  const plaintext = JSON.stringify(value);

  const encrypted = Buffer.concat([
    cipher.update(plaintext, "utf8"),
    cipher.final(),
  ]);
  const authTag = cipher.getAuthTag();

  return `${ENCRYPTION_PREFIX}:${iv.toString("hex")}:${authTag.toString("hex")}:${encrypted.toString("hex")}`;
}

function decryptValue(value) {
  if (value === undefined || value === null) {
    return null;
  }

  if (typeof value !== "string" || !value.startsWith(`${ENCRYPTION_PREFIX}:`)) {
    // Backward compatibility for old plaintext rows.
    return value;
  }

  const key = getEncryptionKey();
  const parts = value.split(":");
  if (parts.length !== 5) {
    throw new Error("Encrypted profile payload is malformed");
  }

  const iv = Buffer.from(parts[2], "hex");
  const authTag = Buffer.from(parts[3], "hex");
  const encrypted = Buffer.from(parts[4], "hex");

  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(authTag);

  const decrypted = Buffer.concat([decipher.update(encrypted), decipher.final()]);
  return JSON.parse(decrypted.toString("utf8"));
}

function toNumberOrNull(value) {
  if (value === undefined || value === null) {
    return null;
  }
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
}

export function encryptProfilePayload(profile = {}) {
  return {
    ...profile,
    age: encryptValue(profile.age),
    gender: encryptValue(profile.gender),
    weight: encryptValue(profile.weight),
    height: encryptValue(profile.height),
    goal: encryptValue(profile.goal),
    bodyType: encryptValue(profile.bodyType),
  };
}

export function decryptProfilePayload(profile = {}) {
  return {
    ...profile,
    age: toNumberOrNull(decryptValue(profile.age)),
    gender: decryptValue(profile.gender),
    weight: toNumberOrNull(decryptValue(profile.weight)),
    height: toNumberOrNull(decryptValue(profile.height)),
    goal: decryptValue(profile.goal),
    bodyType: decryptValue(profile.bodyType),
  };
}
