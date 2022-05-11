import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { Doctor, DoctorDocument } from './schemas/doctor.schema';

@Injectable()
export class DoctorsService {

  constructor(
    @InjectModel(Doctor.name) private readonly doctorModel: Model<DoctorDocument>
  ) {}

  async create(createDoctorDto: CreateDoctorDto): Promise<Doctor> {
    const createdDoctor = await this.doctorModel.create(createDoctorDto);
    return createdDoctor;
  }

  async findAll(): Promise<Doctor[]> {
    return this.doctorModel.find().exec();
  }
}
