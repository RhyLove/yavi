#!/bin/bash
set -e
n=16

for i in `seq 1 ${n}`;do
  class="Combining${i}"
  file="$(dirname $0)/../src/main/java/am/ik/yavi/fn/${class}.java"
  echo $file
  cat <<EOF > ${file}
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
package am.ik.yavi.fn;

/**
 * Generated by
 * https://github.com/making/yavi/blob/develop/scripts/generate-applicative.sh
 *
 * @since 0.6.0
 */
public class ${class}<E, $(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done) | sed 's/,$//')> {
$(for j in `seq 1 ${i}`;do echo "	protected final Validation<E, T${j}> v${j};";echo;done)

	public ${class}($(echo $(for j in `seq 1 ${i}`;do echo -n "Validation<E, T${j}> v${j}, ";done) | sed 's/,$//')) {
$(for j in `seq 1 ${i}`;do echo "		this.v${j} = v${j};";done)
	}

	public <R, V extends Validation<E, R>> V apply(Function${i}<$(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done) | sed 's/,$//'), R> f) {
$(for j in `seq 1 ${i}`;do
		  if [ ${j} -lt ${i} ];then
          echo "		final Validation<E, $(for k in `seq $((j + 1)) ${i}`;do echo -n "Function1<T$k, ";done)R>$(for k in `seq $((j + 1)) ${i}`;do echo -n ">";done) apply${j} = v${j}.apply($(if [ "${j}" == "1" ];then echo "Validation.success(Functions.curry(f))";else echo "apply$((${j} - 1))";fi));"
      else
          if [ ${i} -gt 1 ];then
            echo "		return v${j}.apply(apply$((${j} - 1)));"
          else
            echo "		return v1.apply(Validation.success(Functions.curry(f)));"
          fi
		  fi
		done)
	}
$(if [ ${i} -lt ${n} ];then echo;echo "	public <T$((${i} + 1))> Combining$((${i} + 1))<E, $(echo $(for j in `seq 1 $((${i} + 1))`;do echo -n "T${j}, ";done) | sed 's/,$//')> combine(Validation<E, T$((${i} + 1))> v$((${i} + 1))) {"; echo "		return new Combining$((${i} + 1))<>($(echo $(for j in `seq 1 $((${i} + 1))`;do echo -n "v${j}, ";done) | sed 's/,$//'));"; echo "	}"; else echo -n "";fi)
}
EOF
done

class="Validations"
file="$(dirname $0)/../src/main/java/am/ik/yavi/fn/${class}.java"
echo $file
cat <<EOF > ${file}
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
package am.ik.yavi.fn;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Supplier;

import static java.util.function.Function.identity;

/**
 * Generated by
 * https://github.com/making/yavi/blob/develop/scripts/generate-applicative.sh
 *
 * @since 0.6.0
 */
public class ${class} {
$(for i in `seq 1 ${n}`;do echo "	public static <E, $(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done) | sed 's/,$//')> Combining${i}<E, $(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done) | sed 's/,$//')> combine($(echo $(for j in `seq 1 ${i}`;do echo -n "Validation<E, T${j}> v${j}, ";done) | sed 's/,$//')) {"; echo "		return new Combining${i}<>($(echo $(for j in `seq 1 ${i}`;do echo -n "v${j}, ";done) | sed 's/,$//'));"; echo "	}";echo;done)

$(for i in `seq 1 ${n}`;do echo "	public static <R, E, $(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done) | sed 's/,$//'), V extends Validation<E, R>> V apply(Function${i}<$(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done) | sed 's/,$//'), R> f, $(echo $(for j in `seq 1 ${i}`;do echo -n "Validation<E, T${j}> v${j}, ";done) | sed 's/,$//')) {"; echo "		return combine($(echo $(for j in `seq 1 ${i}`;do echo -n "v${j}, ";done) | sed 's/,$//')).apply(f);"; echo "	}";echo;done)

	public static <E, T> Validation<E, List<T>> sequence(
			Iterable<? extends Validation<? extends E, ? extends T>> validations) {
		return traverse(validations, identity());
	}

	public static <E, T, U> Validation<E, List<U>> traverse(Iterable<T> values,
			Function<? super T, ? extends Validation<? extends E, ? extends U>> mapper) {
		return traverseIndexed(values, IndexedTraverser.ignoreIndex(mapper));
	}

	/**
	 * @since 0.7.0
	 */
	@FunctionalInterface
	public interface IndexedTraverser<A, R> {
		R apply(A a, int index);
		static <A, R> IndexedTraverser<A, R> ignoreIndex(Function<? super A, ? extends R> f) {
			return (a, index) -> f.apply(a);
		}
	}

	/**
	 * @since 0.7.0
	 */
	public static <E, T, U> Validation<E, List<U>> traverseIndexed(Iterable<T> values,
			IndexedTraverser<? super T, ? extends Validation<? extends E, ? extends U>> traverser) {
		return traverseIndexed(values, traverser, ArrayList::new);
	}

	/**
	 * @since 0.8.0
	 */
	public static <E, T, U, C extends Collection<U>> Validation<E, C> traverseIndexed(
			Iterable<T> values,
			IndexedTraverser<? super T, ? extends Validation<? extends E, ? extends U>> traverser,
			Supplier<C> factory) {
		final List<E> errors = new ArrayList<>();
		final C results = factory.get();
		int index = 0;
		for (T value : values) {
			traverser.apply(value, index++).fold(errors::addAll, results::add);
		}
		return errors.isEmpty() ? Validation.success(results)
				: Validation.failure(errors);
	}

	/**
	 * @since 0.8.0
	 */
	@SuppressWarnings("unchecked")
	public static <E, T, U> Validation<E, Optional<U>> traverseOptional(Optional<T> value,
			Function<? super T, ? extends Validation<? extends E, ? extends U>> mapper) {
		return value.map(
				t -> mapper.apply(t).bimap(es -> (List<E>) es, u -> Optional.of((U) u))) //
				.orElse(Validation.success(Optional.empty()));
	}

}
EOF

class="Functions"
file="$(dirname $0)/../src/main/java/am/ik/yavi/fn/${class}.java"
echo $file
cat <<EOF > ${file}
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
package am.ik.yavi.fn;

/**
 * Generated by
 * https://github.com/making/yavi/blob/develop/scripts/generate-applicative.sh
 *
 * @since 0.6.0
 */
public class ${class} {
$(for i in `seq 1 ${n}`;do echo "	public static <$(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done)) R> $(echo $(for j in `seq 1 ${i}`;do echo -n "Function1<T${j}, ";done)) R$(echo $(for j in `seq 1 ${i}`;do echo -n ">";done)) curry(Function${i}<$(echo $(for j in `seq 1 ${i}`;do echo -n "T${j}, ";done)) R> f) {"; echo "		return $(echo $(for j in `seq 1 ${i}`;do echo -n "t${j} -> ";done)) f.apply($(echo $(for j in `seq 1 ${i}`;do echo -n "t${j}, ";done) | sed 's/,$//'));"; echo "	}";echo;done)
}
EOF
