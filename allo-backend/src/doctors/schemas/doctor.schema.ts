import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document } from "mongoose";

export type DoctorDocument = Doctor & Document;

@Schema()
export class Doctor {
    @Prop()
    email: string;

    @Prop()
    password: string;

    @Prop()
    firstName: string;

    @Prop()
    lastName: string;

    @Prop()
    doctorCredentialId: string;
}

export const DoctorSchema = SchemaFactory.createForClass(Doctor);