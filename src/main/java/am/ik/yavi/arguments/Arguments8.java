/*
 * Copyright (C) 2018-2024 Toshiaki Maki <makingx@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package am.ik.yavi.arguments;

import am.ik.yavi.fn.Function8;
import am.ik.yavi.jsr305.Nullable;

/**
 * Generated by https://github.com/making/yavi/blob/develop/scripts/generate-args.sh
 *
 * @since 0.3.0
 */
public class Arguments8<A1, A2, A3, A4, A5, A6, A7, A8>
		extends Arguments7<A1, A2, A3, A4, A5, A6, A7> {

	protected final A8 arg8;

	Arguments8(@Nullable A1 arg1, @Nullable A2 arg2, @Nullable A3 arg3, @Nullable A4 arg4,
			@Nullable A5 arg5, @Nullable A6 arg6, @Nullable A7 arg7, @Nullable A8 arg8) {
		super(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
		this.arg8 = arg8;
	}

	@Nullable
	public final A8 arg8() {
		return this.arg8;
	}

	public final <X> X map(
			Function8<? super A1, ? super A2, ? super A3, ? super A4, ? super A5, ? super A6, ? super A7, ? super A8, ? extends X> mapper) {
		return mapper.apply(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
	}
}
