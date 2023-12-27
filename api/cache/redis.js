"use strict";

import dotenv from "dotenv";
import { createClient } from "redis";

dotenv.config();

// env variables
const host = process.env.REDIS_HOST || "";
const user = process.env.REDIS_HOST || "";
const password = process.env.REDIS_PASSWORD || "";
const port = process.env.REDIS_PORT || "";

const redisUrl = `redis://default:${password}@${host}:${port}`;

const client = createClient({ url: redisUrl });

export const setCache = async (key, value) => {
  await client.connect();
  client.on("error", (err) => {
    console.log("Error connecting to redis", err);
  });

  const data = JSON.stringify({ isCached: true, data: value });
  await client.set(key, data);
  return client.disconnect();
};

export const getCache = async (key) => {
  await client.connect();

  client.on("error", (err) => {
    console.log("Error connecting to redis", err);
  });

  const data = await client.get(key);
  await client.disconnect();
  return data;
};

export const deleteCache = async (key) => {
  await client.connect();
  await client.del(key);
  return client.disconnect();
};
